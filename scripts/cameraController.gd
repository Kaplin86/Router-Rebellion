extends Camera3D

@export var targetObject : Node3D
@export var offset : Vector3 = Vector3.ZERO
@export var speed : float = 1

func _process(delta):
	if targetObject:
		global_position = lerp(position, targetObject.global_position + offset, delta * speed)
		look_at(targetObject.global_position)
