extends Node3D

@export var Item : BulletPayload

func _on_area_3d_body_entered(body):
	if body is PlayerCharacter:
		body.attemptToGetItem(Item)
		process_mode = Node.PROCESS_MODE_DISABLED
		queue_free()
	pass # Replace with function body.
