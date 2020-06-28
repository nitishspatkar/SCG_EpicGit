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
		'pointsAdditionElement',
		'parentArtifact',
		'editedArtifact'
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
	| saveButton title user action goal criteria points userStory |
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
			editedArtifact ifNotNil: [ 
				editedArtifact title: title; user: user; action: action; goal: goal; acceptCriteria: criteria; points: points.
				 ] ifNil: [ 
				userStory := (EUserStory new title: title; user: user; action: action; goal: goal; acceptCriteria: criteria; points: points).
				reqContainer addArtifact: userStory.
				 ].
			parentArtifact ifNotNil: [ parentArtifact addUserStory: userStory ].
			reqContainer announcer announce: ERequirementStateChangedAnnouncement.
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
	|container titleLabel aDocument textElement actionText |
	container:= BlElement new 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].

	titleLabel:= self blLabelFor: 'Action: '.
	
	editedArtifact ifNotNil: [ actionText := editedArtifact action ] ifNil: [ actionText := ('What is the action in this story?') ].
	
	aDocument := GtDocument new.
	aDocument editor useSyncStylerStrategy.
	aDocument text: actionText.
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
	|container titleLabel aDocument textElement criteriaText |
	container:= BlElement new 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].

	titleLabel:= self blLabelFor: 'Acceptance criteria: '.
	
	editedArtifact ifNotNil: [ criteriaText := editedArtifact acceptCriteria ] ifNil: [ criteriaText := ('What are the acceptance criteria of this story?') ].
	
	aDocument := GtDocument new.
	aDocument editor useSyncStylerStrategy.
	aDocument text: criteriaText.
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
	|container titleLabel aDocument textElement goalText |
	container:= BlElement new 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].

	titleLabel:= self blLabelFor: 'Goal: '.
	
	editedArtifact ifNotNil: [ goalText := editedArtifact goal ] ifNil: [ goalText := ('What is the goal in this story?') ].
	
	aDocument := GtDocument new.
	aDocument editor useSyncStylerStrategy.
	aDocument text: goalText.
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
	|container titleLabel aDocument textElement pointsText |
	container:= BlElement new 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].

	titleLabel:= self blLabelFor: 'Points: '.
	
	editedArtifact ifNotNil: [ pointsText := editedArtifact points asString ] ifNil: [ pointsText := ('How many implementation points does this story have?') ].
	
	aDocument := GtDocument new.
	aDocument editor useSyncStylerStrategy.
	aDocument editor inputFilter: BrTextEditorDigitInputFilter new.
	aDocument text: pointsText.
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
EUserStoryAdditionMenu >> initializeUserAdditionElement [
	|container titleLabel aDocument textElement userText |
	container:= BlElement new 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].

	titleLabel:= self blLabelFor: 'User: '.
	
	editedArtifact ifNotNil: [ userText := editedArtifact user ] ifNil: [ userText := ('Who is the user in this story?') ].
	
	aDocument := GtDocument new.
	aDocument editor useSyncStylerStrategy.
	aDocument text: userText.
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

{ #category : #initialization }
EUserStoryAdditionMenu >> initializeWithContainer: anERequirementContainer andElement: aRequirement [
	editedArtifact := aRequirement.
	self initializeWithContainer: anERequirementContainer.
]

{ #category : #initialization }
EUserStoryAdditionMenu >> initializeWithContainer: anERequirementContainer andParent: aParent [
	super initialize.
	parentArtifact := aParent.
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
