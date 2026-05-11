extends BaseStatusEffect
class_name SlowingStatus

## Refers to the percentage deducted of movement speed per potency
@export var factor = 0.02

func get_stat_changes() -> Dictionary[String,Variant]:
	return {
		"movementSpeed_MULT": 1 - (factor * potency)
	}
