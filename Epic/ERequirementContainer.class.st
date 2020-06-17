Class {
	#name : #ERequirementContainer,
	#superclass : #Object,
	#instVars : [
		'project',
		'requirements'
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
	"execute this whenever an artifact is added to the container. 
	This ensures that all of the artifact's subelements are added as well"
			
	| children |
	children := anArtifact children.
	children do: [ :each | self addArtifact: each ].
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
		initialize: self mindMapGenerate.
]

{ #category : #initialization }
ERequirementContainer >> initialize [
	project := 'Empty project'.
	requirements := OrderedCollection new.
]

{ #category : #ui }
ERequirementContainer >> mindMapGenerate [
	"Generate a Mind Map mondrian for the gtMindMap view"
	| view requirementContentLabel |
	view := GtMondrian new.
	requirementContentLabel := BrLabel new
		look: (BrGlamorousLabelLook new glamorousRegularFontAndSize);
		padding: (BlInsets all: 20);
		alignCenter.
	view nodes
		shape: [ :anArtifact |
			BlElement new
				look: (BrGlamorousWithTooltipLook2
					content: (requirementContentLabel text: (anArtifact title asRopedText))
					);
				size: 10 @ 10;
				border: (BlBorder paint: Color gray width: 1);
				geometry: BlCircle new ];
		with: requirements.
	view edges connectFrom: [:x | x ] toAll: [:x | x children].
	view edges
		shape: [ :x | 
			BlLineElement new
				border: (BlBorder paint: (Color red alpha: 0.5) width: 2) ].
	view layout explicit: GtGraphClusterLayout new.
	^ view
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
ERequirementContainer >> requirements: aCollection [ 
	requirements := aCollection.
]
