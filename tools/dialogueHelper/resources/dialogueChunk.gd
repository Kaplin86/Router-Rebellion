extends Resource
class_name dialogueChunk

## A resource that stores one instance of dialogue

## The text of the speaking character
@export var text = ""
## The speaking character
@export_enum("left","right") var speakingChar : int
## Visual name of the left character
@export var leftCharName = ""
## Visual name of the left character
@export var rightCharName = ""
## Filepath to the model of the left character
@export var leftCharModel : String = ""
## Animation name for left character
@export var leftAnim : String = ""
## Filepath to the model of right character
@export var rightCharModel : String
## Animation name for right character
@export var rightAnim : String = ""
