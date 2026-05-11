extends Area3D
class_name BulletObject

var payload : BulletPayload

var raycast : ShapeCast3D = null

var team = 0

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
			print("dying from collider", collider)
			queue_free()
	
	global_position += targetPos

func destroyableColider(obj):
	if obj is BaseAttackable:
		if obj.team != team:
			var damage = payload.baseDamage * sqrt(payload.speed) * payload.size 
			obj.takeDamage(damage,payload)
			obj.statuses.append_array(payload.statusEffects)
			return true
		return false
	return true
