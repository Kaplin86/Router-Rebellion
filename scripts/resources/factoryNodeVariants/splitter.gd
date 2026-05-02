extends FactoryNode
class_name SplitterNode

@export var ratio = 0.5

func apply_effect(payload: BulletPayload) -> Array[BulletPayload]:
	var p1 = payload.duplicate()
	var p2 = payload.duplicate()
	p1.size *= ratio
	p2.size *= 1-ratio
	return [p1,p2]
