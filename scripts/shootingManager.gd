extends Node

@export var shootPos : Node3D

@onready var cooldown = Timer.new()
@onready var baseBullet = preload("res://scenes/bullet.tscn")


var canFire = true

var bullets = []

func _ready():
	add_child(cooldown)
	cooldown.wait_time = 0.2
	cooldown.one_shot = true
	cooldown.timeout.connect(_resetCooldown)

func _process(delta):
	if canFire:
		if Input.is_action_pressed("shoot"):
			shoot()

func shoot():
	canFire = false
	cooldown.start()
	print("FIRE IN THE HOLE!")
	var newBullet : Node3D = baseBullet.instantiate()
	get_parent().add_sibling(newBullet)
	newBullet.global_position = shootPos.global_position
	

func _resetCooldown():
	canFire = true
