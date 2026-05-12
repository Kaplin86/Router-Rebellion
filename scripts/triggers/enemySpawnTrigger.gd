extends Area3D
class_name EnemySpawnTrigger

var spawned = false
var enemies : Array[BaseAttackable] = []

func _ready() -> void:
	connect("body_entered",checkPlayer)

func checkPlayer(body):
	if body is PlayerCharacter and !spawned:
		spawned = true
		spawn()

func spawn():
	for I in get_children():
		I.process_mode = Node.PROCESS_MODE_INHERIT
		I.visible = true
		if I is BaseAttackable:
			enemies.append(I)
			I.die.connect(onEnemyKilled.bind(I))

func onEnemyKilled(enemy):
	enemies.erase(enemy)
	
	if enemies.size() == 0:
		for I in get_children():
			I.process_mode = Node.PROCESS_MODE_DISABLED
			I.visible = false
