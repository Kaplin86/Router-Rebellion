extends Control

@export var textNode : RichTextLabel
@export var nameNode : RichTextLabel

@export var leftCharacter : String = ""
@export var rightCharacter : String = ""

func _ready():
	await doDialogue("Hi! I am capsule construct! reporting for duty!",leftCharacter,leftCharacter,rightCharacter)
	await doDialogue("Ok twin.",rightCharacter,leftCharacter,rightCharacter)
	await doDialogue("I dont wanna hear it!!! you silly single-capsule creature!!",leftCharacter,leftCharacter,rightCharacter)
	await doDialogue("Maybe we shouldn't judge a person by their form, but rather by their nature on the inside!!!",rightCharacter,leftCharacter,rightCharacter)

func doDialogue(text : String = "", speaker : String = "Nobody", leftChar = null, rightChar = null):
	if leftChar != leftCharacter:
		# set the model
		pass
	if rightChar != rightChar:
		# set the model
		pass
	
	leftCharacter = leftChar
	rightCharacter = rightChar
	
	# set text
	nameNode.text = ""
	nameNode.size.x = 5
	
	
	textNode.text = text
	var newTween = create_tween()
	var firstTween = newTween
	textNode.visible_ratio = 0.0
	newTween.tween_property(textNode,"visible_ratio",1,2)
	
	
	# move nameBar
	newTween = create_tween()
	newTween.set_ease(Tween.EASE_IN_OUT)
	newTween.set_trans(Tween.TRANS_CUBIC)
	if rightChar == speaker:
		newTween.tween_property(nameNode,"global_position",Vector2(1083.0,401),0.5)
		nameNode.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	else:
		newTween.tween_property(nameNode,"global_position",Vector2(78,401),0.5)
		nameNode.grow_horizontal = Control.GROW_DIRECTION_END
	
	nameNode.text = "[i]" + speaker + "[/i]"
	
	await firstTween.finished
