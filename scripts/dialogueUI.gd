@tool
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



func _process(delta):
	if !Engine.is_editor_hint():
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

func doDialogue(dialogue : dialogueChunk):
	if dialogue.leftCharName != leftCharacter:
		# set the model
		pass
	if dialogue.rightCharName != rightCharacter:
		# set the model
		pass
	
	leftCharacter = dialogue.leftCharName
	rightCharacter = dialogue.rightCharName
	
	var moveBox = false
	
	var speakerName
	match dialogue.speakingChar:
		0: speakerName = leftCharacter
		1: speakerName = rightCharacter
	
	if lastSpeaker != speakerName:
		moveBox = true
		lastSpeaker = speakerName
		if dialogue.speakingChar == 1:
			bounce(rightCharNode)
		else:
			bounce(leftCharNode)
	
	# set text
	nameNode.text = "[i]" + speakerName + "[/i]"
	nameNode.reset_size()
	
	textNode.text = dialogue.text
	textNode.visible_ratio = 0.0	
	
	
	# move nameBar
	if moveBox:
		await get_tree().process_frame
		await get_tree().process_frame
		var newTween = create_tween()
		newTween.set_ease(Tween.EASE_OUT)
		newTween.set_trans(Tween.TRANS_QUINT)
		if dialogue.speakingChar == 1:
			newTween.tween_property(nameNode,"global_position",Vector2(1083.0 - nameNode.size.x,401),0.5)
			
			#nameNode.grow_horizontal = Control.GROW_DIRECTION_BEGIN
		else:
			newTween.tween_property(nameNode,"global_position",Vector2(78,401),0.5)
			
			#nameNode.grow_horizontal = Control.GROW_DIRECTION_END
	
	for I in dialogue.text:
		textNode.visible_characters += 1
		if I in [".",",","?","!",":"]:
			await get_tree().create_timer(0.1).timeout
		else:
			await get_tree().create_timer(0.03).timeout
	await continuPressed
