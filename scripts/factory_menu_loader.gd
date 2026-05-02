extends Node

var open = false

var BASEfactoryScene = preload("res://scenes/factory/baseFactoryRealm.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("delete"):
		var newScene = BASEfactoryScene.instantiate()
		newScene.save = References.currentFactorySave
		add_child(newScene)
		open = true
		newScene.connect("closed",close)

func close():
	open = false
	get_child(0).queue_free()
	
