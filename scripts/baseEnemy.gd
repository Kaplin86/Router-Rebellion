extends CharacterBody3D
class_name BaseEnemy

@export var hp = 20
@export var maxhp = 20
@export var detectionRange = 15

@export var healthBar : ProgressBar

var collisionArea : Area3D
var targetedPlayer : PlayerCharacter
var targeting = false

func _ready():
	createArea(detectionRange)

func _process(delta):
	healthBar.max_value = maxhp
	healthBar.value = hp
	checkDeath()
	
	if targeting:
		look_at(targetedPlayer.global_position)

func checkDeath():
	if hp <= 0:
		queue_free()
		process_mode = Node.PROCESS_MODE_DISABLED

func createArea(range):
	var newCollisionShape = CollisionShape3D.new()
	var newShape = SphereShape3D.new()
	newShape.radius = range
	newCollisionShape.shape = newShape
	var area = Area3D.new()
	area.add_child(newCollisionShape)
	add_child(area)
	collisionArea = area
	area.body_entered.connect(onEnter)

func onEnter(body : Node3D):
	if body is PlayerCharacter:
		targetedPlayer = body
		targeting = true
