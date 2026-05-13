extends Control

@export var textNode : RichTextLabel
@export var nameNode : RichTextLabel

@export var leftCharacter : String = ""
@export var rightCharacter : String = ""

@export var leftCharNode : Sprite2D
@export var rightCharNode : Sprite2D

signal continuPressed

var time := 0.0
var bounceTarget = null

var lastSpeaker = ""

func _ready():
	await doDialogue("Hi! I am capsule construct! reporting for duty!",leftCharacter,leftCharacter,rightCharacter)
	await doDialogue("wHAT A GOOD DAY IT IS TO BE A CAPSULE CONSTRUCT!",leftCharacter,leftCharacter,rightCharacter)
	await doDialogue("Ok twin.",rightCharacter,leftCharacter,rightCharacter)
	await doDialogue("I dont wanna hear it!!! you silly single-capsule creature!!",leftCharacter,leftCharacter,rightCharacter)
	await doDialogue("Maybe we shouldn't judge a person by their form, but rather by their nature on the inside!!!",rightCharacter,leftCharacter,rightCharacter)
	await doDialogue("How fun, am i right or am i right?",rightCharacter,leftCharacter,rightCharacter)

func _process(delta):
	if Input.is_action_just_pressed("continue_text"):
		emit_signal("continuPressed")
		
	doBounce(delta)

func doBounce(delta):
	if bounceTarget:
		time += delta

		var A = 40.0
		var k = 4.0
		var omega = 12.0

		var offset = A * exp(-k * time) * cos(omega * time)

		bounceTarget.offset.y = offset

func bounce(node):
	time = 0
	if bounceTarget:bounceTarget.offset.y = 0
	
	bounceTarget = node

func doDialogue(text : String = "", speaker : String = "Nobody", leftChar = null, rightChar = null):
	if leftChar != leftCharacter:
		# set the model
		pass
	if rightChar != rightChar:
		# set the model
		pass
	
	leftCharacter = leftChar
	rightCharacter = rightChar
	
	var moveBox = false
	
	if lastSpeaker != speaker:
		moveBox = true
		lastSpeaker = speaker
		if rightChar == speaker:
			bounce(rightCharNode)
		else:
			bounce(leftCharNode)
	
	# set text
	nameNode.text = "[i]" + speaker + "[/i]"
	nameNode.reset_size()
	
	textNode.text = text
	textNode.visible_ratio = 0.0	
	
	
	# move nameBar
	if moveBox:
		await get_tree().process_frame
		await get_tree().process_frame
		var newTween = create_tween()
		newTween.set_ease(Tween.EASE_OUT)
		newTween.set_trans(Tween.TRANS_QUINT)
		if rightChar == speaker:
			newTween.tween_property(nameNode,"global_position",Vector2(1083.0 - nameNode.size.x,401),0.5)
			
			#nameNode.grow_horizontal = Control.GROW_DIRECTION_BEGIN
		else:
			newTween.tween_property(nameNode,"global_position",Vector2(78,401),0.5)
			
			#nameNode.grow_horizontal = Control.GROW_DIRECTION_END
	
	for I in text:
		textNode.visible_characters += 1
		if I in [".",",","?","!",":"]:
			await get_tree().create_timer(0.1).timeout
		else:
			await get_tree().create_timer(0.03).timeout
	await continuPressed
