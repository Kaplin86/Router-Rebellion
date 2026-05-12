extends Control

@export var paralaxSkewNode : Node2D

var dt = 0

func _process(delta: float) -> void:
	dt += delta
	animateUI()

func animateUI():
	if paralaxSkewNode:
		paralaxSkewNode.skew = sin(dt) * 0.1
