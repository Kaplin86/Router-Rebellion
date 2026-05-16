@tool
extends Control

var current : DialogueHolder
var currentChunk : dialogueChunk
var path : String

var buttonScene = preload("res://tools/dialogueHelper/dialogueMinibutton.tscn")

@export var DialogueButtonContainer : Control
@export var dialoguePlayer : Control

@export var textBox : TextEdit
@export var leftName : LineEdit
@export var rightName : LineEdit
@export var speakingSide : CheckButton
@export var leftModelButton : Button
@export var rightModelButton : Button
@export var leftModelAnims : OptionButton
@export var rightModelAnims : OptionButton

func _ready():
	current = DialogueHolder.new()

func loadDialogueButtons():
	$Overarching/FileSelect/Select.text = path
	
	for I in DialogueButtonContainer.get_children():
		I.queue_free()
	
	var index = -1
	for I in current.dialogue:
		index += 1
		if I is dialogueChunk:
			
			var newButton : Button = buttonScene.instantiate()
			DialogueButtonContainer.add_child(newButton)
			newButton.find_child("Text",true).text = I.text
			newButton.find_child("Number",true).text = str(index)
			newButton.pressed.connect(displayChunk.bind(I))
			newButton.find_child("Up",true).pressed.connect(moveChunkUp.bind(I))
			newButton.find_child("Down",true).pressed.connect(moveChunkDown.bind(I))
			
			if index == 0:
				newButton.find_child("Up",true).disabled = true
			if index == current.dialogue.size() - 1:
				newButton.find_child("Down",true).disabled = true



func _on_button_pressed():
	path = createDialogueFromPath(await fileAsk(["*.tres"]))
	loadDialogueButtons()

func fileAsk(filter):
	var file_dialog = FileDialog.new()
	file_dialog.filters = PackedStringArray(filter)
	
	get_parent().add_child(file_dialog)
	file_dialog.popup_centered_ratio()
	var temp = await file_dialog.file_selected
	
	
	
	await get_tree().process_frame
	var wind :Window = get_parent()
	wind.grab_focus()
	return temp


func createDialogueFromPath(wowpath):
	var resource = null
	if FileAccess.file_exists(wowpath):
		var loaded = load(wowpath)
		if not loaded is DialogueHolder:
			resource = DialogueHolder.new()
		else:
			resource = DialogueHolder.new()
			for I in loaded.dialogue:
				resource.dialogue.append(I)
	else:
		resource = DialogueHolder.new()
	return resource

func _on_add_empty_pressed():
	var newDIALOGUE = dialogueChunk.new()
	current.dialogue.append(newDIALOGUE)
	loadDialogueButtons()

func moveChunkUp(chunk : dialogueChunk):
	var index = current.dialogue.find(chunk)
	var swapIndex = index - 1
	var oldVal = current.dialogue.get(swapIndex)
	current.dialogue.remove_at(swapIndex)
	current.dialogue.insert(index,oldVal)
	
	loadDialogueButtons()
	
func moveChunkDown(chunk : dialogueChunk):
	var index = current.dialogue.find(chunk)
	var swapIndex = index + 1
	var oldVal = current.dialogue.get(index)
	current.dialogue.remove_at(index)
	current.dialogue.insert(swapIndex,oldVal)
	loadDialogueButtons()

func displayChunk(chunk : dialogueChunk):
	currentChunk = chunk
	
	textBox.text = currentChunk.text
	leftName.text = currentChunk.leftCharName
	rightName.text = currentChunk.rightCharName
	speakingSide.button_pressed = bool(currentChunk.speakingChar)
	leftModelButton.text = currentChunk.leftCharModel
	rightModelButton.text = currentChunk.rightCharModel
	
	loadChoiceButton(leftModelAnims,getAnimsFromModel(currentChunk.leftCharModel),currentChunk.leftAnim)
	loadChoiceButton(rightModelAnims,getAnimsFromModel(currentChunk.rightCharModel),currentChunk.rightAnim)
	
	updateDisplay()

func getAnimsFromModel(modelpath):
	if !FileAccess.file_exists(modelpath):
		return []
	var packed : PackedScene = load(modelpath)
	var model : Node = packed.instantiate()
	var animationPlayer : AnimationPlayer= model.find_children("*","AnimationPlayer")[0]
	var anims = animationPlayer.get_animation_list()
	return Array(anims)

func loadChoiceButton(node : OptionButton,options : Array, choice = null):
	node.clear()
	for I in options:
		node.add_item(I)
	
	if choice != null:
		if options.find(choice):
			node.selected = options.find(choice)
		

func updateDisplay():
	dialoguePlayer.doDialogue(currentChunk)


func on_any_change(param = null, param2 = null, param3 = null):
	currentChunk.text = textBox.text
	currentChunk.leftCharName = leftName.text
	currentChunk.rightCharName = rightName.text
	currentChunk.speakingChar = int(speakingSide.button_pressed)
	currentChunk.leftCharModel = leftModelButton.text
	currentChunk.rightCharModel = rightModelButton.text
	
	var selectedIdLeft = leftModelAnims.get_selected_id()
	var selectedIdRight = rightModelAnims.get_selected_id()
	
	loadChoiceButton(leftModelAnims,getAnimsFromModel(currentChunk.leftCharModel))
	loadChoiceButton(rightModelAnims,getAnimsFromModel(currentChunk.rightCharModel))
	
	if leftModelAnims.item_count != 0:
		currentChunk.leftAnim = leftModelAnims.get_item_text(selectedIdLeft)
		print("anim is set to",currentChunk.leftAnim )
	if rightModelAnims.item_count != 0:
		currentChunk.rightAnim = rightModelAnims.get_item_text(selectedIdRight)
	
	loadChoiceButton(leftModelAnims,getAnimsFromModel(currentChunk.leftCharModel),currentChunk.leftAnim)
	loadChoiceButton(rightModelAnims,getAnimsFromModel(currentChunk.rightCharModel),currentChunk.rightAnim)
	
	updateDisplay()
	loadDialogueButtons()


func _on_set_l_model_pressed():
	var modelpath = await fileAsk(["*.tscn"])
	leftModelButton.text = modelpath
	on_any_change()
