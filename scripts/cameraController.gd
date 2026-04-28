extends Camera3D

@export var targetObject : Node3D
@export var offset : Vector3 = Vector3.ZERO

func _process(delta):
	if targetObject:
		global_position = lerp(position, targetObject.global_position + offset, delta)
		look_at(targetObject.global_position)
