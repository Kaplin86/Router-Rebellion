extends CharacterBody3D
class_name BaseEnemy

@export var hp = 20
@export var maxhp = 20

@export var healthBar : ProgressBar

func _process(delta):
	healthBar.max_value = maxhp
	healthBar.value = hp
	checkDeath()

func checkDeath():
	if hp <= 0:
		queue_free()
		process_mode = Node.PROCESS_MODE_DISABLED
