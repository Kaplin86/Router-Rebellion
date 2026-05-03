extends FactoryNode
class_name RefinerNode

@export var sizeChange = 0.90
@export var damageChange = 1.10
@export var speedChange = 1.0

func apply_effect(payload: BulletPayload) -> Array[BulletPayload]:
	payload.size *= sizeChange
	payload.baseDamage *= damageChange
	payload.speed *= speedChange
	return [payload]
