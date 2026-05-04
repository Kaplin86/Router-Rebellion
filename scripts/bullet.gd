extends Area3D

var payload : BulletPayload

var raycast : ShapeCast3D = null

func _ready():
	raycast = ShapeCast3D.new()
	raycast.shape = $CollisionShape3D.shape
	add_child(raycast)

func _process(delta):
	var forward_vector = -global_transform.basis.z.normalized()
	var targetPos = forward_vector * payload.speed * delta
	
	raycast.global_position = global_position
	raycast.target_position = targetPos
	
	if raycast.get_collision_count() != 0:
		var collider = raycast.get_collider(0)
		if destroyableColider(collider):
			queue_free()
	
	global_position += targetPos

func destroyableColider(obj):

	if obj is PlayerCharacter:
		return false
	if obj is BaseEnemy:
		obj.hp -= payload.baseDamage
		
	return true
