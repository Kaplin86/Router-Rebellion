extends Control

@export_category("outer nodes")
@export var player : PlayerCharacter

@export_category("children")
@export var healthBar : ProgressBar
@export var statusLog : VBoxContainer

func _process(delta):
	if healthBar and player:
		healthBar.value = player.hp
		healthBar.max_value = player.maxHp

func addStatus(text : String):
	var newPanel = Panel.new()
	statusLog.add_child(newPanel)
	var newText = RichTextLabel.new()
	newPanel.add_child(newText)
	newText.text
