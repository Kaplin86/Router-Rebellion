extends FactoryNode
class_name RefinerNode

@export var sizeChange = 0.90
@export var damageChange = 1.10

func apply_effect(payload: BulletPayload) -> Array[BulletPayload]:
	payload.size *= sizeChange
	payload.baseDamage *= damageChange
	return [payload]
