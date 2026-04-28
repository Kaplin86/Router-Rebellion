extends CharacterBody3D

@export var speed = 9.0

func _physics_process(delta):
	var motion = transform.basis.z * speed * delta
	print(motion)
	var collision = move_and_collide(motion)

	if collision:
		rotation = rotation.bounce(collision.get_normal())
