Class {
	#name : #ERequirementContainer,
	#superclass : #Object,
	#instVars : [
		'project',
		'requirements',
		'announcer'
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
ERequirementContainer >> createArtifactAdditionDropdown [
	"I create and return a Dropdown menu for adding artifacts in the Mind Map view"
	^ self toggleButton
		look:
			BrGlamorousButtonWithLabelAndIconLook
				+
					(BrGlamorousWithDropdownLook
						handle: [ self toggleButton
								look:
									BrGlamorousButtonWithLabelAndIconLook - BrGlamorousButtonExteriorLook;
								yourself ]
						content: [ self popupArtifactList ]);
		label: 'Add Artifact';
		relocate: 200 @ 100;
		yourself
]

{ #category : #helper }
ERequirementContainer >> getAvailableArtifactTypesForDropdown [
	"I return a collection of artifact types, which can be selected in the dropdown menu in the Mind Map view"
	| result |
	result := OrderedCollection new.
	requirements do: [ :each | 
		(result includes: (each class name)) ifFalse: [ result add: (each class name) ]
		]. 
	^result
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
				border: (BlBorder paint: Color gray width: 1);
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
					self addArtifact: (EEpic new title:'Yo').
					self announcer announce: ERequirementStateChangedAnnouncement new 
					] 
				];
		fitContent;
		items: self getAvailableArtifactTypesForDropdown.	
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
	| look |
	look := BrGlamorousWithTooltipLook2 
		content: 
		(BrLabel new 
			look: BrGlamorousLabelLook new glamorousRegularFontAndSize; 
			padding: (BlInsets all: 20); 
			alignCenter; 
			text: anArtifact title asRopedText).
	^look
]

{ #category : #ui }
ERequirementContainer >> toggleButton [
	^ BrButton new
		label: 'Add Artifact';
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
