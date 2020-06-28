Class {
	#name : #EScenarioAdditionMenu,
	#superclass : #BlElement,
	#instVars : [
		'reqContainer',
		'titleAdditionElement',
		'descriptionAdditionElement',
		'parentArtifact',
		'editedArtifact'
	],
	#category : #'Epic-Model'
}

{ #category : #ui }
EScenarioAdditionMenu >> blLabelFor: text [
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

{ #category : #ui }
EScenarioAdditionMenu >> createSaveButton [
	| saveButton title description scenario |
	saveButton := (BrButton new
		background: (Color fromHexString: 'eaeaea');
		margin: (BlInsets top: 15 left: 15 bottom: 0 right: 0);
		padding: (BlInsets all: 3);
		look: BrGlamorousButtonWithLabelLook new;
		label: 'Save';
		action: [ 
			self inform: 'Clicked save button.'.
			title := ((titleAdditionElement children at:2) document text) asString.
			description := ((descriptionAdditionElement children at:2) document text) asString.
			editedArtifact ifNotNil: [ 
				editedArtifact title: title.
				editedArtifact description: description.
				 ] ifNil: [ 
				scenario := (EScenario new title: title; description: description).
				reqContainer addArtifact: scenario.
				 ].
			parentArtifact ifNotNil: [ parentArtifact addScenario: scenario ].
			reqContainer announcer announce: ERequirementStateChangedAnnouncement.
			]).
	^saveButton
]

{ #category : #initialization }
EScenarioAdditionMenu >> initialize [
	super initialize.
	self 
	layout: BlLinearLayout vertical;
	constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent. ].
	
	titleAdditionElement := self initializeTitleAdditionElement.
	descriptionAdditionElement := self initializeDescriptionAdditionElement.
	
	self addChild: titleAdditionElement.
	self addChild: descriptionAdditionElement.
	self addChild: self createSaveButton.
]

{ #category : #initialization }
EScenarioAdditionMenu >> initializeDescriptionAdditionElement [
	|container titleLabel aDocument textElement descriptionText |
	container:= BlElement new 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].

	titleLabel:= self blLabelFor: 'Description: '.
	
	editedArtifact ifNotNil: [ descriptionText := editedArtifact description ] ifNil: [ descriptionText := ('Give me a description') ].
	
	aDocument := GtDocument new.
	aDocument editor useSyncStylerStrategy.
	aDocument text: descriptionText.
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
EScenarioAdditionMenu >> initializeTitleAdditionElement [
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
EScenarioAdditionMenu >> initializeWithContainer: anERequirementContainer [
	self initialize.
	reqContainer := anERequirementContainer.
]

{ #category : #initialization }
EScenarioAdditionMenu >> initializeWithContainer: anERequirementContainer andElement: aRequirement [
	editedArtifact := aRequirement.
	self initializeWithContainer: anERequirementContainer.
]

{ #category : #initialization }
EScenarioAdditionMenu >> initializeWithContainer: anERequirementContainer andParent: aRequirement [
	self initialize.
	reqContainer := anERequirementContainer.
	parentArtifact := aRequirement.
	
]
