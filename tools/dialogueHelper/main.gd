@tool
extends EditorScript
class_name DialogueHelper

var window : Window

func _run():
	
	window = Window.new()
	EditorInterface.popup_dialog(window,Rect2(300,300,1600,1000))
	
	var scene = load("res://tools/dialogueHelper/dialogueHelperScene.tscn").instantiate()
	window.add_child(scene)
	
	window.close_requested.connect(func():
		onCloseRequest())
	

func onCloseRequest():
	window.queue_free()
