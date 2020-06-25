Class {
	#name : #EUseCaseAdditionMenu,
	#superclass : #BlElement,
	#instVars : [
		'reqContainer',
		'titleAdditionElement',
		'taskAdditionElement',
		'actorDropdown',
		'selectedActor',
		'parentArtifact'
	],
	#category : #'Epic-Model'
}

{ #category : #ui }
EUseCaseAdditionMenu >> blLabelFor: text [
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
EUseCaseAdditionMenu >> createSaveButton [
	| saveButton title task useCase |
	saveButton := (BrButton new
		background: (Color fromHexString: 'eaeaea');
		margin: (BlInsets top: 15 left: 15 bottom: 0 right: 0);
		padding: (BlInsets all: 3);
		look: BrGlamorousButtonWithLabelLook new;
		label: 'Save';
		action: [ 
			self inform: 'Clicked save button.'.
			title := ((titleAdditionElement children at:2) document text) asString.
			task := ((taskAdditionElement children at:2) document text) asString.
			useCase := (EUseCase new title: title; task: task; addActor: (EActor new name: selectedActor)).
			reqContainer addArtifact: useCase.
			parentArtifact ifNotNil: [ parentArtifact addUseCase: useCase ].
			reqContainer updateGraph.
			]).
	^saveButton
]

{ #category : #helper }
EUseCaseAdditionMenu >> getActors [
	^reqContainer getActors
]

{ #category : #initialization }
EUseCaseAdditionMenu >> initialize [
	super initialize.
	self 
	layout: BlLinearLayout vertical;
	constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent. ].
	
	titleAdditionElement := self initializeTitleAdditionElement.
	taskAdditionElement := self initializeTaskAdditionElement.
	actorDropdown := self initializeActorAdditionDropdown.
	
	self addChild: titleAdditionElement.
	self addChild: taskAdditionElement.
	self addChild: actorDropdown.
	self addChild: self createSaveButton.
]

{ #category : #initialization }
EUseCaseAdditionMenu >> initializeActorAdditionDropdown [
	"I create and return a dropdown toggle button for adding artifacts in the Mind Map view"
	| dropdownLook |
	^ self toggleButton
		margin: (BlInsets top: 15 left: 15 bottom: 0 right: 0);
		padding: (BlInsets all: 3);
		look:
			BrGlamorousButtonWithLabelAndIconLook
				+
					(dropdownLook := BrGlamorousWithDropdownLook
						handle: [ self toggleButton
								look:
									BrGlamorousButtonWithLabelAndIconLook - BrGlamorousButtonExteriorLook;
								yourself ]
						content: [ self popupActorList 
							addShortcut:
								(BlShortcut new
								combination: BlKeyCombination builder return build;
								action: [ dropdownLook hide ]).
								]);
		label: 'Add Actor';
		relocate: 200 @ 100;
		yourself
]

{ #category : #initialization }
EUseCaseAdditionMenu >> initializeTaskAdditionElement [
	|container taskLabel aDocument textElement |
	container:= BlElement new 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].

	taskLabel:= self blLabelFor: 'Task: '.
	
	aDocument := GtDocument new.
	aDocument editor useSyncStylerStrategy.
	aDocument text: ('What is my task?').
	textElement := aDocument asElementWithoutSaveAction
			vFitContent;
			hMatchParent.
	textElement	
		border: (BlBorder paint: (Color fromHexString: 'eaeaea') width: 2);
		margin: (BlInsets top: 15 left: 15 bottom: 0 right: 0);
		padding: (BlInsets all: 3);
		geometry: (BlRectangle cornerRadius: 5).
	
		
	container addChild: taskLabel.		
	container addChild: textElement.		
	
	^ container.	
]

{ #category : #initialization }
EUseCaseAdditionMenu >> initializeTitleAdditionElement [
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
EUseCaseAdditionMenu >> initializeWithContainer: anERequirementContainer [
	super initialize.
	reqContainer := anERequirementContainer.
	
	self 
	layout: BlLinearLayout vertical;
	constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent. ].
	
	titleAdditionElement := self initializeTitleAdditionElement.
	taskAdditionElement := self initializeTaskAdditionElement.
	actorDropdown := self initializeActorAdditionDropdown.
	self addChild: titleAdditionElement.
	self addChild: taskAdditionElement.
	self addChild: actorDropdown.
	self addChild: self createSaveButton.
]

{ #category : #initialization }
EUseCaseAdditionMenu >> initializeWithContainer: anERequirementContainer andParent: aParent [
	"I initialize my creation menu with a specified parent element, which will be linked to the element that is created from the menu."
	super initialize.
	parentArtifact := aParent.
	reqContainer := anERequirementContainer.
	
	self 
	layout: BlLinearLayout vertical;
	constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent. ].
	
	titleAdditionElement := self initializeTitleAdditionElement.
	taskAdditionElement := self initializeTaskAdditionElement.
	actorDropdown := self initializeActorAdditionDropdown.
	self addChild: titleAdditionElement.
	self addChild: taskAdditionElement.
	self addChild: actorDropdown.
	self addChild: self createSaveButton.
]

{ #category : #ui }
EUseCaseAdditionMenu >> popupActorList [
	| actorList |
	actorList := BrSimpleList new.
	actorList
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
					actorList selectOne: index.
					selectedActor := each.
					]
				];
		addShortcut:
			(BlShortcut new
				combination: BlKeyCombination builder return build;
				action: [  
					self initializeActorAdditionDropdown look hide 
					]);
		fitContent;
		items: self getActors.
	^actorList
]

{ #category : #ui }
EUseCaseAdditionMenu >> toggleButton [
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
