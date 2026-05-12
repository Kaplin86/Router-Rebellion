extends Control

@export var paralaxSkewNode : Node2D
@export var playButton : Button

var dt = 0

func _process(delta: float) -> void:
	dt += delta
	animateUI()

func animateUI():
	if paralaxSkewNode:
		paralaxSkewNode.skew = sin(dt) * 0.1


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/testing.tscn")
