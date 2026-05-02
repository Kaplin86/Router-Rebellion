extends Node
class_name BulletPayload

@export var size = 1.0
@export var baseDamage = 1.0
@export var visualType = ""

func _to_string() -> String:
	return visualType + "(" + str(size) + " size, " + str(baseDamage) + " dmg)" 
