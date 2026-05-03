extends Node

var open = false

var BASEfactoryScene = preload("res://scenes/factory/baseFactoryRealm.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("delete") and !open:
		var newScene = BASEfactoryScene.instantiate()
		newScene.save = References.currentFactorySave
		add_child(newScene)
		open = true
		newScene.connect("closed",close)
		get_parent().process_mode = Node.PROCESS_MODE_DISABLED

func close():
	open = false
	get_child(0).queue_free()
	get_parent().process_mode = Node.PROCESS_MODE_INHERIT
