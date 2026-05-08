extends Control
class_name UiManager

@export_category("outer nodes")
@export var player : PlayerCharacter

@export_category("children")
@export var healthBar : ProgressBar
@export var statusLog : VBoxContainer
@export var inventoryPanels : Array[Panel]


var logs = 0

func _process(delta):
	if healthBar and player:
		healthBar.value = player.Hp
		healthBar.max_value = player.MaxHp
		
		renderPlayerInventory()

func addStatus(text : String):
	var newPanel = Panel.new()
	statusLog.add_child(newPanel)
	newPanel.custom_minimum_size = Vector2(0,60)
	var newText = RichTextLabel.new()
	newPanel.add_child(newText)
	newText.text = text
	newText.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	logs += 1
	newPanel.set_meta("number",logs)
	
	for I in statusLog.get_children():
		var offset = logs - I.get_meta("number",0)
		if offset >= 5 and I.get_meta("notFading",true):
			var tween = create_tween()
			I.set_meta("notFading",false)
			tween.tween_property(I,"modulate",Color(0,0,0,0),1)
			tween.tween_callback(I.queue_free)

func renderPlayerInventory():
	var inventory = player.inventory
	print(inventory)
	for I : int in inventory.size():
		var itemData = inventory[I]
		var respectiveItemTile = inventoryPanels[I]
		var texNode : TextureRect = respectiveItemTile.get_child(0)
		var itemChunk  : BulletPayload = itemData.get("item")
		var texture = load("res://sprites/item/" + itemChunk.visualType + ".png")
		if texture == null:
			texture =  load("res://sprites/item/" + itemChunk.visualType + ".svg")
		texNode.texture = texture
		
		var labelNode : Label = respectiveItemTile.get_child(1)
		labelNode.text = "x"+str(itemData.get("count"))
