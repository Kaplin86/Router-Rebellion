@tool
extends Control

var current : DialogueHolder
var path : String

var buttonScene = preload("res://tools/dialogueHelper/dialogueMinibutton.tscn")

@export var DialogueButtonContainer : Control

func loadDialogue():
	$Overarching/FileSelect/Button.text = path
	
	for I in current.dialogue.keys():
		if current.dialogue[I] == dialogueChunk:
			
			var newButton = buttonScene.instantiate()
			DialogueButtonContainer.add_child(newButton)
			newButton.find_child("Text",true).text = I.text
			DialogueButtonContainer.add_child(newButton)
			


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
		current = resource.duplicate(true)
	
	path = temp
	
	loadDialogue()
