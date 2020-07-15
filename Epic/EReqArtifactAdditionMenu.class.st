Class {
	#name : #EReqArtifactAdditionMenu,
	#superclass : #BlElement,
	#instVars : [
		'reqContainer',
		'parentArtifact',
		'editedArtifact'
	],
	#category : #'Epic-Model'
}

{ #category : #ui }
EReqArtifactAdditionMenu >> blLabelFor: text [
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
EReqArtifactAdditionMenu >> createButtonBar [
	| bar |
	
	bar := BlElement new 
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent.
			 ].
	
	bar addChild: self createSaveButton.
	bar addChild: self createCancelButton.
	bar addChild: 
		(BlElement new
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ];
				yourself).
	
	^bar
]

{ #category : #ui }
EReqArtifactAdditionMenu >> createCancelButton [
	| cancelButton |
	cancelButton := (BrButton new
		background: (Color fromHexString: 'eaeaea');
		margin: (BlInsets top: 15 left: 15 bottom: 0 right: 0);
		padding: (BlInsets all: 3);
		look: BrGlamorousButtonWithIconLook new;
		icon: BrGlamorousIcons close;
		action: [ 
			self inform: 'Clicked cancel button.'.
			reqContainer announcer announce: ERequirementStateChangedAnnouncement.
			]).
	^cancelButton
]

{ #category : #ui }
EReqArtifactAdditionMenu >> createSaveButton [
	| saveButton |
	saveButton := (BrButton new
		background: (Color fromHexString: 'eaeaea');
		margin: (BlInsets top: 15 left: 15 bottom: 0 right: 0);
		padding: (BlInsets all: 3);
		look: BrGlamorousButtonWithLabelLook new;
		label: 'Save';
		action: [ 
			self saveChanges.
			"self inform: 'Clicked save button.'.
			title := ((titleAdditionElement children at:2) document text) asString.
			editedArtifact ifNotNil: [ editedArtifact title: title ] ifNil: [ reqContainer addArtifact: (EEpic new title: title) ].
			reqContainer announcer announce: ERequirementStateChangedAnnouncement."
			]).
	^saveButton
]

{ #category : #initialization }
EReqArtifactAdditionMenu >> initialize [
	super initialize.
	self 
	layout: BlLinearLayout vertical;
	constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent. ].
]

{ #category : #initialization }
EReqArtifactAdditionMenu >> initializeWithContainer: anERequirementContainer [
	reqContainer := anERequirementContainer.
	self initialize.
]

{ #category : #initialization }
EReqArtifactAdditionMenu >> initializeWithContainer: anERequirementContainer andElement: aRequirement [
	editedArtifact := aRequirement.
	self initializeWithContainer: anERequirementContainer.
]

{ #category : #initialization }
EReqArtifactAdditionMenu >> initializeWithContainer: anERequirementContainer andParent: aParent [
	"I initialize my creation menu with a specified parent element, which will be linked to the element that is created from the menu."
	parentArtifact := aParent.
	reqContainer := anERequirementContainer.
	self initialize.
]

{ #category : #accessing }
EReqArtifactAdditionMenu >> reqContainer [
	^reqContainer
]

{ #category : #'morphic ui' }
EReqArtifactAdditionMenu >> saveChanges [
	^ self subclassResponsibility
]

{ #category : #ui }
EReqArtifactAdditionMenu >> titleFor: text [
	^ BrLabel new
		text: text;
		padding: (BlInsets all: 5);
		geometry: (BlRectangle cornerRadius: 5);
		look: (BrGlamorousLabelLook new glamorousRegularFontAndSize; fontSize: 22); 
		constraintsDo: [ :c | 
			c linear vertical alignCenter.
			c linear horizontal alignCenter ].
]
