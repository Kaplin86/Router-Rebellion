extends FactoryNode
class_name SetterNode

@export var size = INF
@export var damage = INF
@export var speed = INF
@export var spread = INF

func apply_effect(payload: BulletPayload) -> Array[BulletPayload]:
	if size != INF: payload.size = size
	if damage != INF: payload.baseDamage = damage
	if speed != INF: payload.speed = speed
	if spread != INF: payload.spread = spread
	return [payload]
