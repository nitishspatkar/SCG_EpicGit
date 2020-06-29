Class {
	#name : #ERequirementContainer,
	#superclass : #Object,
	#instVars : [
		'project',
		'requirements',
		'announcer',
		'theGraph',
		'graphPane'
	],
	#category : #'Epic-Model'
}

{ #category : #adding }
ERequirementContainer >> addArtifact: anArtifact [
	requirements add: anArtifact.
	self addArtifactChildren: anArtifact.
]

{ #category : #adding }
ERequirementContainer >> addArtifactChildren: anArtifact [
	"I execute this whenever an artifact is added to my container. 
	This ensures that all of the artifact's subelements are added as well"
	| children |
	children := anArtifact children.
	children do: [ :each | self addArtifact: each ].
]

{ #category : #accessing }
ERequirementContainer >> announcer [
	^announcer
]

{ #category : #ui }
ERequirementContainer >> buildButtonBar [
	| buttonBar |
	buttonBar := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ];
		layout: BlLinearLayout horizontal;
		yourself.
	
	buttonBar
		addChild:
			(BlElement new
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ];
				yourself).
	buttonBar
		addChild:
			(BrButton new
				look: BrGlamorousButtonWithLabelLook;
				label: 'Add Epic';
				action: [ 
					graphPane removeChildren.
					graphPane addChild: (self createAddEpicMenu).
					]).
	buttonBar
		addChild:
			(BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousIcons zoomin;
				label: 'Zoom In';
				action: [ theGraph zoomIn ]).
	buttonBar
		addChild:
			(BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousIcons zoomout;
				label: 'Zoom Out';
				action: [ theGraph zoomOut ]).
	buttonBar
		addChild:
			(BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousIcons zoomtofit;
				label: 'Fit';
				action: [ theGraph zoomToFit ]).
	buttonBar
		addChild:
			(BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousIcons actualsize;
				label: 'Resize';
				action: [ theGraph zoomToActualSize ]).
	buttonBar
		addChild:
			(BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousVectorIcons refresh;
				label: 'Refresh';
				action: [ self announcer announce: ERequirementStateChangedAnnouncement ]).
	^ buttonBar
]

{ #category : #helper }
ERequirementContainer >> computeEpicColor: anEpic [
	"I compute and return a color based on the combined status of the epic's associated use cases"
	| useCases color r g b numberOfCases |
	r := 0. g := 0. b := 0.
	useCases := anEpic children.
	numberOfCases := useCases size.
	useCases do: [ :each | 
		r := r + (self computeUseCaseColor: each) red.
		g := g + (self computeUseCaseColor: each) green.
		b := b + (self computeUseCaseColor: each) blue.
		 ].
	(numberOfCases = 0) ifFalse: [ 
		r := r / numberOfCases.
		g := g / numberOfCases.
		b := b / numberOfCases.
		 ].
	color := Color r: r g: g b: b.
	^color
]

{ #category : #helper }
ERequirementContainer >> computeUseCaseColor: aUseCase [
	"I compute and return a color based on the combined status of the use case's associated user stories"
	| stories color r g b numberOfStories |
	r := 0. g := 0. b := 0.
	stories := aUseCase children.
	numberOfStories := stories size.
	stories do: [ :each | 
		r := r + each getStateColor red.
		g := g + each getStateColor green.
		b := b + each getStateColor blue.
		 ].
	(numberOfStories = 0) ifFalse: [ 
		r := r / numberOfStories.
		g := g / numberOfStories.
		b := b / numberOfStories.
		 ].
	color := Color r: r g: g b: b.
	^color
]

{ #category : #ui }
ERequirementContainer >> createAddEpicMenu [
	^EEpicAdditionMenu new initializeWithContainer: self.
]

{ #category : #ui }
ERequirementContainer >> createArtifactAdditionDropdown [
	"I create and return a dropdown toggle button for adding artifacts in the Mind Map view"
	| dropdownLook |
	^ self toggleButton
		look:
			BrGlamorousButtonWithLabelAndIconLook
				+
					(dropdownLook := BrGlamorousWithDropdownLook
						handle: [ self toggleButton
								look:
									BrGlamorousButtonWithLabelAndIconLook - BrGlamorousButtonExteriorLook;
								yourself ]
						content: [ self popupArtifactList 
							addShortcut:
								(BlShortcut new
								combination: BlKeyCombination builder return build;
								action: [ dropdownLook hide ]).
								]);
		label: 'Add Requirement';
		relocate: 200 @ 100;
		yourself
]

{ #category : #ui }
ERequirementContainer >> generateAdditionMenuFor: anArtifact [
	"return an addition menu for the supplied artifact"
	| menu artifactType |
	artifactType := anArtifact class.
	(artifactType = EEpic) ifTrue: [ menu := (EUseCaseAdditionMenu new initializeWithContainer: self andParent: anArtifact) ].
	(artifactType = EUseCase) ifTrue: [ (menu := EUserStoryAdditionMenu new initializeWithContainer: self andParent: anArtifact) ].
	(artifactType = EUserStory) ifTrue: [ (menu := EScenarioAdditionMenu new initializeWithContainer: self andParent: anArtifact) ].
	^menu
]

{ #category : #ui }
ERequirementContainer >> generateEditMenuFor: anArtifact [
	| menu artifactType |
	artifactType := anArtifact class.
	(artifactType = EEpic) ifTrue: [ menu := (EEpicAdditionMenu new initializeWithContainer: self andElement: anArtifact) ].
	(artifactType = EUseCase) ifTrue: [ menu := (EUseCaseAdditionMenu new initializeWithContainer: self andElement: anArtifact) ].
	(artifactType = EUserStory) ifTrue: [ menu := (EUserStoryAdditionMenu new initializeWithContainer: self andElement: anArtifact) ].
	(artifactType = EScenario) ifTrue: [ menu := (EScenarioAdditionMenu new initializeWithContainer: self andElement: anArtifact) ].
	^menu
]

{ #category : #ui }
ERequirementContainer >> generateMindMapView [
	graphPane := BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
		
	theGraph := (self gtMindMapFor: GtPhlowEmptyView new) asElementDo: [ :e | e ].
	
	theGraph 
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent.
			 ].
	
	graphPane addChild: self buildButtonBar.
	graphPane addChild: theGraph.
	^ graphPane

]

{ #category : #ui }
ERequirementContainer >> generateStoryWallView [
	"comment stating purpose of instance-side message"
	| wall column columnTitle stories workStates |
	
	stories := self getUserStories.
	stories do: [ :story | story announcer: self announcer ].
	
	wall := BlElement new
		layout: BlLinearLayout horizontal;
		padding: (BlInsets all: 5);
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent.
			 ].
	
	workStates := { 'Not started'. 'In progress'. 'Complete' }.
	
	workStates do: [ :aState | 
		column := BlElement new 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent.
			 ].
		
		columnTitle := BrLabel new
		text: aState;
		margin: (BlInsets top: 15 left: 15 bottom: 0 right: 0);
		padding: (BlInsets all: 3);
		geometry: (BlRectangle cornerRadius: 5);
		look: (BrGlamorousLabelLook new glamorousRegularFontAndSize; fontSize: 20); 
		constraintsDo: [ :c | 
			c linear vertical alignCenter.
			c linear horizontal alignCenter ].
		
		column addChild: columnTitle.
		column addChildren: ((stories select: [ :story | story state = aState ]) collect: [ :story | story cardViewGenerate ]).
		wall addChild: column.
		 ].

	^wall asScrollableElement
]

{ #category : #helper }
ERequirementContainer >> getActors [
	"Get all the actors from the use cases in the container"
	| useCases actors |
	useCases := requirements select: [ :each | each class name = 'EUseCase' ].
	actors := OrderedCollection new.
	useCases do: [ :useCase | 
		useCase actor do: [ :actor | 
			(actors includes: actor) ifFalse: [ actors add: actor name ]
			]
		 ].
	^actors
]

{ #category : #helper }
ERequirementContainer >> getAvailableArtifactTypesForDropdown [
	"I return a dictionary of artifact types, which can be selected in the dropdown menu in the Mind Map view"
	| result |
	result := SmallDictionary new.
	requirements do: [ :each | 
		(result includes: (each class name)) ifFalse: [ result at: (each class name) put: each class ]
		]. 
	^result
]

{ #category : #accessing }
ERequirementContainer >> getEpics [
	"I collect and return an OrderedCollection of all the epics from the requirements collection."
	| epics |
	epics := self requirements select: [ :each | each class = EEpic ].
	^epics
]

{ #category : #accessing }
ERequirementContainer >> getScenarios [
	"comment stating purpose of instance-side message"
	| scenarios |
	scenarios := self requirements select: [ :each | each class = EScenario ].
	^scenarios
]

{ #category : #accessing }
ERequirementContainer >> getUseCases [
	"comment stating purpose of instance-side message"
	| useCases |
	useCases := self requirements select: [ :each | each class = EUseCase ].
	^useCases
]

{ #category : #helper }
ERequirementContainer >> getUserStories [
	"comment stating purpose of instance-side message"
	| stories |
	stories := self requirements select: [ :each | each class = EUserStory ].
	^stories
]

{ #category : #ui }
ERequirementContainer >> gtDocumentFor: aView [
	<gtView>
	| aDocument |
	aDocument := GtDocument new
		text:
			'A ${class:name=ERequirementContainer}$ is an object which will hold all of the requirements artifacts for a specific project.

As of now, the supported artifact types are: 
	1. Epics: ${class:name=EEpic}$,
	2. Use cases: ${class:name=EUseCase}$,
	3. User Stories: ${class:name=EUserStory}$,
	4. Agile Scenarios: ${class:name=EScenario}$.

The Mind Map view provides an overview of all the artifacts currently contained within the project. The structure of the map is hierarchical, with the finer-grained artifacts being situated farther from the center of the map.
'.
	^ (aDocument gtTextFor: aView)
		title: 'View Details';
		priority: 1
]

{ #category : #ui }
ERequirementContainer >> gtMindMapFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Tree View';
		priority: 50;
		updateWhen: ERequirementStateChangedAnnouncement in: [ self announcer ];
		painting: [ :aMondrian | self mindMapGenerateFor: aMondrian ]
		
]

{ #category : #ui }
ERequirementContainer >> gtTestViewFor: aView [
	<gtView>
	^ aView explicit
		title: 'Test View';
		priority: 50;
		updateWhen: ERequirementStateChangedAnnouncement in: [ self announcer ];
		stencil: [ self generateMindMapView ].
]

{ #category : #ui }
ERequirementContainer >> gtUserStoryWallViewFor: aView [
	<gtView>
	^ aView explicit
		title: 'Story Wall';
		priority: 50;
		updateWhen: ERequirementStateChangedAnnouncement in: [ self announcer ];
		stencil: [ self generateStoryWallView ].
]

{ #category : #helper }
ERequirementContainer >> handleDropdownSelection: aKey [
	"I take the selection from the artifact addition dropdown menu, and add the selected artifact to my artifact collection."
	| artifactType |
	artifactType := self getAvailableArtifactTypesForDropdown at: aKey.
	graphPane removeChildren.
	graphPane addChild: self createAddEpicMenu.
]

{ #category : #initialization }
ERequirementContainer >> initialize [
	project := 'New project'.
	requirements := OrderedCollection new.
	announcer := Announcer new.
]

{ #category : #ui }
ERequirementContainer >> mindMapGenerate [
	"Generate a Mind Map mondrian for the gtMindMap view"
	^self mindMapGenerateFor: GtMondrian new.
]

{ #category : #ui }
ERequirementContainer >> mindMapGenerateFor: view [
	"Generate a Mind Map mondrian for the gtMindMap view"
	view nodes
		shape: [ :anArtifact |
			BlElement new
				look: (self setUpTooltipLookFor: anArtifact);
				size: (self nodeSizeFor: anArtifact) asPoint;
				border: (BlBorder paint: (self nodeHighlightColorFor: anArtifact) width: 2);
				background: (self nodeBackgroundColorFor: anArtifact);
				geometry: BlCircle new ];
		with: requirements.
	view edges connectFrom: [ :x | x ] toAll: [ :x | x children ].
	view edges
		shape: [ :x | 
			BlLineElement new
				border: (BlBorder paint: (Color red alpha: 0.5) width: 5) ].
	view layout custom: (GtGraphClusterLayout new horizontalGap: 80; verticalGap: 80).
	^ view
]

{ #category : #ui }
ERequirementContainer >> nodeBackgroundColorFor: anArtifact [
	"I Compute and return the color of the artifact node's background for the mind map view"
	| color artifactType |
	color := Color blue.
	artifactType := anArtifact class.
	(artifactType = EEpic) ifTrue: [ 
		color := self computeEpicColor: anArtifact
		 ].
	(artifactType = EUseCase) ifTrue: [ 
		color := self computeUseCaseColor: anArtifact
		 ].
	(artifactType = EUserStory) ifTrue: [ color := anArtifact getStateColor ].
	(artifactType = EScenario) ifTrue: [ color := Color white ].
	
	^color alpha: 0.5
	

]

{ #category : #ui }
ERequirementContainer >> nodeHighlightColorFor: anArtifact [
	"I return a corresponding color for a requirement artifact for the outline of the nodes in the mind map view."
	| artifactType color |
	artifactType := anArtifact class.
	(artifactType = EEpic) ifTrue: [ color := Color red alpha: 0.5 ].
	(artifactType = EUseCase) ifTrue: [ color := Color cyan alpha: 0.5 ].
	(artifactType = EUserStory) ifTrue: [ color := Color blue alpha: 0.5 ].
	(artifactType = EScenario) ifTrue: [ color := Color green alpha: 0.5 ].
	^ color
]

{ #category : #ui }
ERequirementContainer >> nodeSizeFor: anArtifact [
	"I return the size of the node that represents supplied artifact in the mind map view. 
	The size depends on the number of implementation points given to the user stories. Scenarios all have the same size."
	| artifactType size scale |
	size := 10.
	scale := GtPlotterLogarithmicScale new.
	artifactType := anArtifact class.
	(artifactType = EEpic) ifTrue: [ 
		anArtifact children do: [ :useCase | 
			useCase children do: [ :story | size := size + story points ]
			 ].
		 ].
	(artifactType = EUseCase) ifTrue: [ 
		anArtifact children do: [ :story | size := size + story points ].
		 ].
	(artifactType = EUserStory) ifTrue: [ size := anArtifact points ].
	(artifactType = EScenario) ifTrue: [ size := 10 ].
	size := (scale map: size) * 20.
	^ size
]

{ #category : #ui }
ERequirementContainer >> popupArtifactList [
	| artifactList |
	artifactList := BrSimpleList new.
	artifactList
		lookDo: [ :aLook | aLook listElement constraintsDo: [ :c | c maxHeight: 200 ] ];
		layout: BlLinearLayout vertical;
		padding: (BlInsets all: 5);
		vFitContent;
		hExact: 200;
		stencil: [ :each :index | 
			BlTextElement new
				text: each asRopedText;
				constraintsDo: [ :c | c horizontal matchParent ];
				padding: (BlInsets all: 5);
				when: BlClickEvent
					do: [ :anEvent | 
					artifactList selectOne: index.
					self handleDropdownSelection: (each asString).
					"self announcer announce: ERequirementStateChangedAnnouncement new."
					]
				];
		addShortcut:
			(BlShortcut new
				combination: BlKeyCombination builder return build;
				action: [  
					self createArtifactAdditionDropdown look hide 
					]);
		fitContent;
		items: self getAvailableArtifactTypesForDropdown keys.
	^artifactList
]

{ #category : #accessing }
ERequirementContainer >> project [
	^project
]

{ #category : #accessing }
ERequirementContainer >> project: aString [
	"Project name, which will be associated with my container"
	project := aString.
]

{ #category : #removing }
ERequirementContainer >> removeArtifact: anArtifact [
	self removeFromParent: anArtifact.
	requirements remove: anArtifact.
	self removeArtifactChildren: anArtifact.
]

{ #category : #removing }
ERequirementContainer >> removeArtifactChildren: anArtifact [
	"I execute this whenever an artifact is removed from my container. 
	This ensures that all of the artifact's subelements are removed as well"
	| children |
	children := anArtifact children.
	children do: [ :each | self removeArtifact: each ].
]

{ #category : #removing }
ERequirementContainer >> removeFromParent: anArtifact [
	"I remove the supplied artifact from its parent's children list, in order to properly remove any reference of it."
	| artifactType |
	artifactType := anArtifact class.
	(artifactType = EUseCase) ifTrue: [ 
		self getEpics do: [ :each | (each children includes: anArtifact) ifTrue: [ each removeUseCase: anArtifact ]  ].
		 ].
	(artifactType = EUserStory) ifTrue: [ 
		self getUseCases do: [ :each | (each children includes: anArtifact) ifTrue: [ each removeUserStory: anArtifact ]  ].
		 ].
	(artifactType = EScenario) ifTrue: [ 
		self getUserStories do: [ :each | (each children includes: anArtifact) ifTrue: [ each removeScenario: anArtifact ]  ].
		 ].
]

{ #category : #accessing }
ERequirementContainer >> requirements [
 ^requirements
]

{ #category : #accessing }
ERequirementContainer >> requirements: aCollectionOfRequirements [
	"I work with a collection of requirement artifacts, in order to display them in my various views. The supported artifacts can be found in the 'View Details' view of my object."
	requirements := aCollectionOfRequirements.
]

{ #category : #helper }
ERequirementContainer >> setUpTooltipLookFor: anArtifact [
	"set up the tooltip object for the Mind Map view"
	| look tooltipContainer tooltipButtonBar tooltipText tooltipLabel addSubElementButton editElementButton deleteElementButton |
	addSubElementButton := (BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousIcons add;
				label: 'Add sub-element';
				action: [ 
					graphPane removeChildren.
					graphPane addChild: (self generateAdditionMenuFor: anArtifact).
					 ]).
	
	editElementButton := (BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousIcons edit;
				label: 'Edit';
				action: [ 
					graphPane removeChildren.
					graphPane addChild: (self generateEditMenuFor: anArtifact).
					 ]).
	
	deleteElementButton := (BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousIcons remove;
				label: 'Delete this artifact (WARNING: This will delete all sub-elements too!)';
				action: [ 
					self removeArtifact: anArtifact.
					self announcer announce: ERequirementStateChangedAnnouncement.
					 ]).
	
	tooltipText := ('An ', anArtifact class name, ': ', anArtifact title) asRopedText.
	
	tooltipLabel := (BrLabel new 
		look: BrGlamorousLabelLook new glamorousRegularFontAndSize; 
		padding: (BlInsets all: 20); 
		alignCenter; 
		text: tooltipText).
	
	tooltipContainer := (BlElement new 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c vertical fitContent.
			 ]).
	
	tooltipButtonBar := (BlElement new 
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal matchParent.
			 ]).
	
	tooltipContainer addChild: tooltipLabel.
	(anArtifact class = EScenario) ifFalse: [ tooltipButtonBar addChild: addSubElementButton. ].
	tooltipButtonBar addChild: editElementButton.
	tooltipButtonBar addChild: deleteElementButton.
	tooltipContainer addChild: tooltipButtonBar.
	
	look := BrGlamorousWithTooltipLook2 
		content: tooltipContainer.
	^look
]

{ #category : #ui }
ERequirementContainer >> toggleButton [
	^ BrButton new
		label: 'Add Requirement';
		icon:
			(BlElement new
				size: 8 @ 8;
				geometry:
					(BlPolygon
						vertices:
							{(0 @ 0).
							(8 @ 0).
							((8 / 2) rounded @ 8)});
				background: Color lightGray;
				margin: (BlInsets left: 6);
				constraintsDo: [ :c | c linear vertical alignCenter ]);
		yourself
]
