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
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousIcons zoomin;
				label: 'Zoom In';
				action: [ theGraph root zoomIn ]).
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
				action: [ self updateGraph ]).
	^ buttonBar
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
ERequirementContainer >> generateMindMapView [
	| dropdown |
	
	graphPane := BlElement new
		layout: BlLinearLayout vertical;
		border: (BlBorder paint: (Color red) width: 1);
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
		
	theGraph := self mindMapGenerate.
	theGraph root border: (BlBorder paint: (Color blue) width: 1).
	theGraph root
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent.
			 ].
	dropdown := self createArtifactAdditionDropdown.
	
	graphPane addChild: dropdown.
	graphPane addChild: self buildButtonBar.
	graphPane addChild: theGraph root asPannableElement.
	^ graphPane

]

{ #category : #'as yet unclassified' }
ERequirementContainer >> generateStoryWallView [
	"comment stating purpose of instance-side message"
	| view |
	view := GtMondrian new.
	view nodes
		shape: [ :aStory | 
			BlElement new 
			layout: BlLinearLayout horizontal;
			constraintsDo: [ :c | 
				c horizontal fitContent.
				c vertical fitContent.
				 ];
			addChild: aStory cardViewGenerate
			];
		with: self getUserStories.
	view layout grid.
	^view

"view := GtMondrian new.
	view nodes
		shape: [ :anArtifact |
			BlElement new
				look: (self setUpTooltipLookFor: anArtifact);
				size: 10 @ 10;
				border: (BlBorder paint: (self nodeHighlightColorFor: anArtifact) width: 1);
				geometry: BlCircle new ];
		with: requirements.
	view edges connectFrom: [:x | x ] toAll: [:x | x children].
	view edges
		shape: [ :x | 
			BlLineElement new
				border: (BlBorder paint: (Color red alpha: 0.5) width: 2) ].
	view layout custom: GtGraphClusterLayout new.
	^ view"
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

{ #category : #helper }
ERequirementContainer >> getUserStories [
	"comment stating purpose of instance-side message"
	| stories |
	stories := requirements select: [ :each | each class name = 'EUserStory' ].
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
		initialize: self mindMapGenerate.
]

{ #category : #ui }
ERequirementContainer >> gtTestViewFor: aView [
	"To be changed. Demonstrate dynamic addition of artifacts via dropdown menu."
	<gtView>
	^ aView explicit
		title: 'Test View';
		priority: 50;
		updateWhen: ERequirementStateChangedAnnouncement in: [ self announcer ];
		stencil: [ self generateMindMapView ].
]

{ #category : #'as yet unclassified' }
ERequirementContainer >> gtUserStoryWallViewFor: aView [
	"To be changed. Demonstrate dynamic addition of artifacts via dropdown menu."
	<gtView>
	^ aView mondrian
		title: 'Story Wall';
		priority: 50;
		updateWhen: ERequirementStateChangedAnnouncement in: [ self announcer ];
		initialize: self generateStoryWallView.
]

{ #category : #helper }
ERequirementContainer >> handleDropdownSelection: aKey [
	"I take the selection from the artifact addition dropdown menu, and add the selected artifact to my artifact collection."
	| artifactType |
	artifactType := self getAvailableArtifactTypesForDropdown at: aKey.
"	self addArtifact: (artifactType new title: aKey)."
	^self createAddEpicMenu.
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
	| view |
	view := GtMondrian new.
	view nodes
		shape: [ :anArtifact |
			BlElement new
				look: (self setUpTooltipLookFor: anArtifact);
				size: 10 @ 10;
				border: (BlBorder paint: (self nodeHighlightColorFor: anArtifact) width: 1);
				geometry: BlCircle new ];
		with: requirements.
	view edges connectFrom: [:x | x ] toAll: [:x | x children].
	view edges
		shape: [ :x | 
			BlLineElement new
				border: (BlBorder paint: (Color red alpha: 0.5) width: 2) ].
	view layout custom: GtGraphClusterLayout new.
	^ view
]

{ #category : #helper }
ERequirementContainer >> nodeHighlightColorFor: anArtifact [
	"I return a corresponding color for a requirement artifact for the outline of the nodes in the mind map view."
	| artifactType color |
	artifactType := anArtifact class name.
	(artifactType = 'EEpic') ifTrue: [ color := Color red alpha: 0.5 ].
	(artifactType = 'EUseCase') ifTrue: [ color := Color cyan alpha: 0.5 ].
	(artifactType = 'EUserStory') ifTrue: [ color := Color blue alpha: 0.5 ].
	(artifactType = 'EScenario') ifTrue: [ color := Color green alpha: 0.5 ].
	^ color
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
					self announcer announce: ERequirementStateChangedAnnouncement new.
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
	| look tooltipText |
	tooltipText := ('An ', anArtifact class name, ': ', anArtifact title) asRopedText.
	look := BrGlamorousWithTooltipLook2 
		content: 
		(BrLabel new 
			look: BrGlamorousLabelLook new glamorousRegularFontAndSize; 
			padding: (BlInsets all: 20); 
			alignCenter; 
			text: tooltipText).
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

{ #category : #ui }
ERequirementContainer >> updateGraph [
	| newGraph oldGraph |
	oldGraph := theGraph.
	newGraph := self mindMapGenerate.
	oldGraph ifNotNil: [ newGraph zoomTo: oldGraph zoomLevel ].
	graphPane removeChildren.
	graphPane addChild: self createArtifactAdditionDropdown.
	graphPane addChild: self buildButtonBar.
	graphPane addChild: newGraph root asPannableElement.
]
