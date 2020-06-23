Class {
	#name : #EUserStoryAdditionMenu,
	#superclass : #BlElement,
	#instVars : [
		'reqContainer',
		'titleAdditionElement',
		'userAdditionElement',
		'actionAdditionElement',
		'goalAdditionElement',
		'criteriaAdditionElement',
		'pointsAdditionElement'
	],
	#category : #'Epic-Model'
}

{ #category : #ui }
EUserStoryAdditionMenu >> blLabelFor: text [
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
EUserStoryAdditionMenu >> createSaveButton [
	| saveButton title user action goal criteria points |
	saveButton := (BrButton new
		background: (Color fromHexString: 'eaeaea');
		margin: (BlInsets top: 15 left: 15 bottom: 0 right: 0);
		padding: (BlInsets all: 3);
		look: BrGlamorousButtonWithLabelLook new;
		label: 'Save';
		action: [ 
			self inform: 'Clicked save button.'.
			title := ((titleAdditionElement children at:2) document text) asString.
			user := EActor new name: (((userAdditionElement children at:2) document text) asString).
			action := ((actionAdditionElement children at:2) document text) asString.
			goal := ((goalAdditionElement children at:2) document text) asString.
			criteria := ((criteriaAdditionElement children at:2) document text) asString.
			points := (((pointsAdditionElement children at:2) document text) asString) asNumber.
			reqContainer addArtifact: (EUserStory new title: title; user: user; action: action; goal: goal; acceptCriteria: criteria; points: points).
			]).
	^saveButton
]

{ #category : #initialization }
EUserStoryAdditionMenu >> initialize [
	super initialize.
	self 
	layout: BlLinearLayout vertical;
	constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent. ].
	
	titleAdditionElement := self initializeTitleAdditionElement.
	userAdditionElement := self initializeUserAdditionElement.
	actionAdditionElement := self initializeActionAdditionElement.
	goalAdditionElement := self initializeGoalAdditionElement.
	criteriaAdditionElement := self initializeCriteriaAdditionElement.
	pointsAdditionElement := self initializePointsAdditionElement.
	
	self addChild: titleAdditionElement.
	self addChild: userAdditionElement.
	self addChild: actionAdditionElement.
	self addChild: goalAdditionElement.
	self addChild: criteriaAdditionElement.
	self addChild: pointsAdditionElement.
	self addChild: self createSaveButton.
]

{ #category : #initialization }
EUserStoryAdditionMenu >> initializeActionAdditionElement [
	|container titleLabel aDocument textElement |
	container:= BlElement new 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].

	titleLabel:= self blLabelFor: 'Action: '.
	
	aDocument := GtDocument new.
	aDocument editor useSyncStylerStrategy.
	aDocument text: ('What is the action in this story?').
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
EUserStoryAdditionMenu >> initializeCriteriaAdditionElement [
	|container titleLabel aDocument textElement |
	container:= BlElement new 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].

	titleLabel:= self blLabelFor: 'Acceptance criteria: '.
	
	aDocument := GtDocument new.
	aDocument editor useSyncStylerStrategy.
	aDocument text: ('What are the acceptance criteria of this story?').
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
EUserStoryAdditionMenu >> initializeGoalAdditionElement [
	|container titleLabel aDocument textElement |
	container:= BlElement new 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].

	titleLabel:= self blLabelFor: 'Goal: '.
	
	aDocument := GtDocument new.
	aDocument editor useSyncStylerStrategy.
	aDocument text: ('What is the goal in this story?').
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
EUserStoryAdditionMenu >> initializePointsAdditionElement [
	|container titleLabel aDocument textElement |
	container:= BlElement new 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].

	titleLabel:= self blLabelFor: 'Points: '.
	
	aDocument := GtDocument new.
	aDocument editor useSyncStylerStrategy.
	aDocument editor inputFilter: BrTextEditorDigitInputFilter new.
	aDocument text: ('How many implementation points does this story have?').
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

{ #category : #intialization }
EUserStoryAdditionMenu >> initializeTitleAdditionElement [
	|container titleLabel aDocument textElement |
	container:= BlElement new 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].

	titleLabel:= self blLabelFor: 'Title: '.
	
	aDocument := GtDocument new.
	aDocument editor useSyncStylerStrategy.
	aDocument text: ('Give me a title').
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
EUserStoryAdditionMenu >> initializeUserAdditionElement [
	|container titleLabel aDocument textElement |
	container:= BlElement new 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].

	titleLabel:= self blLabelFor: 'User: '.
	
	aDocument := GtDocument new.
	aDocument editor useSyncStylerStrategy.
	aDocument text: ('Who is the user in this story?').
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
EUserStoryAdditionMenu >> initializeWithContainer: anERequirementContainer [
	super initialize.
	reqContainer := anERequirementContainer.
	self 
	layout: BlLinearLayout vertical;
	constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent. ].
	
	titleAdditionElement := self initializeTitleAdditionElement.
	userAdditionElement := self initializeUserAdditionElement.
	actionAdditionElement := self initializeActionAdditionElement.
	goalAdditionElement := self initializeGoalAdditionElement.
	criteriaAdditionElement := self initializeCriteriaAdditionElement.
	pointsAdditionElement := self initializePointsAdditionElement.
	
	self addChild: titleAdditionElement.
	self addChild: userAdditionElement.
	self addChild: actionAdditionElement.
	self addChild: goalAdditionElement.
	self addChild: criteriaAdditionElement.
	self addChild: pointsAdditionElement.
	self addChild: self createSaveButton.
]
