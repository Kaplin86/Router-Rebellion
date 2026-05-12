extends Area3D
class_name EnemySpawnTrigger

var spawned = false

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
