Extension { #name : #GtCreateBehaviorElement }

{ #category : #'*Epic' }
GtCreateBehaviorElement >> forClassDefinitionWithName: aString [
	headerModel := GtBehaviorCoderHeaderModel new
		definition: (GtClassDefinition forNewWithName: aString).
	self addChild: self buildDefinitionEditor
]
