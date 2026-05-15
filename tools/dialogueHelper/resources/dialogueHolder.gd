extends Resource
class_name DialogueHolder

## A node for storing one dialogue instance (an instance referring to a chain that is not interrupted), alongside any additional data.

## An array of dialogue. 
@export var dialogue : Array[dialogueChunk] = []
