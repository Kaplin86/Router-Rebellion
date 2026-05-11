extends BaseEnemy
class_name Melee


@export var attackRange = 5


var agent : NavigationAgent3D
var canAttack = true

func targetingBehavior(delta): 
	if !agent:
		agent = NavigationAgent3D.new()
		add_child(agent)
		agent.avoidance_enabled = true
		agent.radius = 1
	
	
	agent.target_position = target.global_position
	
	var nextPos = agent.get_next_path_position()
	if nextPos != global_position:
		nextPos = Vector3(nextPos.x,global_position.y,nextPos.z)
		print(movementSpeed)
		velocity = global_position.direction_to(nextPos) * delta * movementSpeed
		move_and_slide()
		look_at(nextPos)
		
		attemptAttack()

func attemptAttack():
	if canAttack:
		if target.global_position.distance_squared_to(global_position) <= attackRange:
			canAttack = false
			playAnimation("attack")
			damageTarget()
			await get_tree().create_timer(attackSpeed).timeout
			canAttack = true

func damageTarget():
	target.takeDamage(round(damage + (damage * randf_range(0,randomDamageFactor))))
