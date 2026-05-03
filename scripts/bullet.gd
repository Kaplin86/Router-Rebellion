extends Area3D

var speed = 6

func _process(delta):
	var forward_vector = -global_transform.basis.z.normalized()
	global_position += forward_vector * speed * delta
