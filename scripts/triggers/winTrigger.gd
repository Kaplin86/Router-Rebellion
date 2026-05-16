extends Area3D
class_name WinTrigger


func _ready() -> void:
	connect("body_entered",checkPlayer)

func checkPlayer(body):
	if body is PlayerCharacter :
		print("we have a winner!!! yippeee!!!")
		get_tree().change_scene_to_file("res://scenes/uiElements/win.tscn")
