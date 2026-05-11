extends Resource
class_name BaseStatusEffect
@export var type = ""
@export var potency : int
@export var count : int

enum TickType { ON_HIT, DISTANCE_TRAVELED, HIT_WALL, ON_SHOOT}
 
func get_stat_changes() -> Dictionary[String,Variant]:

	return {
		"accuracy": -potency * 0.1,
		"stun": false
	}

func onFirstApplication(): pass

func tick(type : TickType, data := {}): pass
