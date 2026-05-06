extends BaseEnemy
class_name Melee

@export var movementSpeed = 50
@export var attackSpeed = 0.6
@export var attackRange = 5
@export var baseDamage = 5
@export var randomDamageFactor = 0.15


var agent : NavigationAgent3D
var canAttack = true

func targetingBehavior(delta): 
	if !agent:
		agent = NavigationAgent3D.new()
		add_child(agent)
		agent.avoidance_enabled = true
		agent.radius = 1
	
	agent.target_position = targetedPlayer.global_position
	
	var nextPos = agent.get_next_path_position()
	if nextPos != global_position:
		nextPos = Vector3(nextPos.x,global_position.y,nextPos.z)
		velocity = global_position.direction_to(nextPos) * delta * movementSpeed
		move_and_slide()
		look_at(nextPos)
		
		attemptAttack()

func attemptAttack():
	if canAttack:
		if targetedPlayer.global_position.distance_squared_to(global_position) <= attackRange:
			canAttack = false
			playAnimation("attack")
			damageTarget()
			await get_tree().create_timer(attackSpeed).timeout
			canAttack = true

func damageTarget():
	targetedPlayer.takeDamage(round(baseDamage + (baseDamage * randf_range(0,randomDamageFactor))))
