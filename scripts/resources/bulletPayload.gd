extends Resource
class_name BulletPayload

@export var size = 1.0
@export var baseDamage = 1.0
@export var visualType = ""
@export var speed = 5.0
@export var spread = 3

func _to_string() -> String:
	return visualType + "(" + str(size) + " size, " + str(baseDamage) + " dmg)" 

func is_equal(item : BulletPayload):
	
	if item.get("size") == size:
		if item.baseDamage == baseDamage:
			if item.visualType == visualType:
				return true
	return false
