extends BaseAttackable
class_name BaseEnemy

@export var detectionRange = 15

@export_category("nodes")
@export var healthBar : ProgressBar

var collisionArea : Area3D
var targetedPlayer : PlayerCharacter
var targeting = false



func _ready():
	createArea(detectionRange)

func _process(delta):
	healthBar.max_value = MaxHp
	healthBar.value = Hp
	checkDeath()
	
	if targeting:
		targetingBehavior(delta)

func targetingBehavior(delta):
	look_at(targetedPlayer.global_position)


func checkDeath():
	if Hp <= 0:
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
