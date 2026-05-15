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
	var file_dialog = FileDialog.new()
	file_dialog.filters = PackedStringArray(["*.tres"])
	EditorInterface.get_base_control().add_child(file_dialog)
	file_dialog.popup_centered_ratio()
	var temp = await file_dialog.file_selected
	var resource = null
	if FileAccess.file_exists(temp):
		resource = load(temp)
		if not resource is DialogueHolder:
			resource = null
			current = DialogueHolder.new()
		else:
			
			current = DialogueHolder.new()
			for I in resource.dialogue:
				current.dialogue.append(I)
	else:
		resource = DialogueHolder.new()
	
	path = temp
	await get_tree().process_frame
	var wind :Window = get_parent()
	wind.grab_focus()
	loadDialogueButtons()


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
	
	updateDisplay()

func updateDisplay():
	dialoguePlayer.doDialogue(currentChunk)


func on_any_change(param = null, param2 = null, param3 = null):
	currentChunk.text = textBox.text
	currentChunk.leftCharName = leftName.text
	currentChunk.rightCharName = rightName.text
	currentChunk.speakingChar = int(speakingSide.button_pressed)
	
	updateDisplay()
	loadDialogueButtons()
