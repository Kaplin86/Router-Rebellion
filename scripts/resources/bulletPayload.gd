extends Node
class_name BulletPayload

@export var size = 1.0
@export var baseDamage = 1.0
@export var visualType = ""
@export var speed = 5.0
@export var spread = 3

func _to_string() -> String:
	return visualType + "(" + str(size) + " size, " + str(baseDamage) + " dmg)" 
