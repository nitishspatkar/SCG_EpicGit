Class {
	#name : #EEpicAdditionMenu,
	#superclass : #BlElement,
	#instVars : [
		'reqContainer',
		'titleAdditionElement',
		'editedArtifact'
	],
	#category : #'Epic-Model'
}

{ #category : #helper }
EEpicAdditionMenu >> blLabelFor: text [
	^ BrLabel new
		text: text;
		margin: (BlInsets top: 15 left: 15 bottom: 0 right: 0);
		padding: (BlInsets all: 3);
		geometry: (BlRectangle cornerRadius: 5);
		look: (BrGlamorousLabelLook new glamorousRegularFontAndSize; fontSize: 20); 
		constraintsDo: [ :c | 
			c linear vertical alignCenter.
			c linear horizontal alignLeft ].
]

{ #category : #initialization }
EEpicAdditionMenu >> createSaveButton [
	| saveButton title |
	saveButton := (BrButton new
		background: (Color fromHexString: 'eaeaea');
		margin: (BlInsets top: 15 left: 15 bottom: 0 right: 0);
		padding: (BlInsets all: 3);
		look: BrGlamorousButtonWithLabelLook new;
		label: 'Save';
		action: [ 
			self inform: 'Clicked save button.'.
			title := ((titleAdditionElement children at:2) document text) asString.
			editedArtifact ifNotNil: [ editedArtifact title: title ] ifNil: [ reqContainer addArtifact: (EEpic new title: title) ].
			"reqContainer updateGraph."
			reqContainer announcer announce: ERequirementStateChangedAnnouncement.
			]).
	^saveButton
]

{ #category : #initialization }
EEpicAdditionMenu >> initialize [
	super initialize.
	self 
	layout: BlLinearLayout vertical;
	constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent. ].
	
	titleAdditionElement := self initializeTitleAdditionElement.
	self addChild: titleAdditionElement.
	self addChild: self createSaveButton.
]

{ #category : #initialization }
EEpicAdditionMenu >> initializeTitleAdditionElement [
	|container titleLabel aDocument textElement titleText |
	container:= BlElement new 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].

	titleLabel:= self blLabelFor: 'Title: '.
	
	editedArtifact ifNotNil: [ titleText := editedArtifact title ] ifNil: [ titleText := ('Give me a title') ].
	
	aDocument := GtDocument new.
	aDocument editor useSyncStylerStrategy.
	aDocument text: titleText.
	textElement := aDocument asElementWithoutSaveAction
			vFitContent;
			hMatchParent.
	textElement	
		border: (BlBorder paint: (Color fromHexString: 'eaeaea') width: 2);
		margin: (BlInsets top: 15 left: 15 bottom: 0 right: 0);
		padding: (BlInsets all: 3);
		geometry: (BlRectangle cornerRadius: 5).
	
		
	container addChild: titleLabel.		
	container addChild: textElement.		
	
	^ container.	
]

{ #category : #initialization }
EEpicAdditionMenu >> initializeWithContainer: anERequirementContainer [
	super initialize.
	reqContainer := anERequirementContainer.
	
	self 
	layout: BlLinearLayout vertical;
	constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent. ].
	
	titleAdditionElement := self initializeTitleAdditionElement.
	self addChild: titleAdditionElement.
	self addChild: self createSaveButton.
]

{ #category : #initialization }
EEpicAdditionMenu >> initializeWithContainer: anERequirementContainer andElement: aRequirement [
	editedArtifact := aRequirement.
	self initializeWithContainer: anERequirementContainer.
]

{ #category : #accessing }
EEpicAdditionMenu >> reqContainer [
	^reqContainer
]

{ #category : #accessing }
EEpicAdditionMenu >> titleAdditionElement [
	^titleAdditionElement
]
