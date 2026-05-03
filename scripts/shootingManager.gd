extends Node

@export var shootPos : Node3D
@export var cooldownTime = 0.2
@export var spread = 15
@export var maxFireSize = 1.5

@onready var cooldown = Timer.new()
@onready var baseBullet = preload("res://scenes/bullet.tscn")



var canFire = true


func _ready():
	add_child(cooldown)
	cooldown.wait_time = cooldownTime
	cooldown.one_shot = true
	cooldown.timeout.connect(_resetCooldown)
	
	
	



func _process(delta):
	if canFire:
		if Input.is_action_pressed("shoot"):
			var value : Array[BulletPayload] = References.runFactorySave(References.currentFactorySave,BulletPayload.new())
			value = getFinalPayloads(value)
			shoot(value)

func getFinalPayloads(bullets: Array[BulletPayload]):

	return bullets

func shoot(bullets: Array[BulletPayload]):
	canFire = false
	cooldown.start()
	for I in bullets:
		var newBullet : Node3D = baseBullet.instantiate()
		get_parent().add_sibling(newBullet)
		newBullet.global_position = shootPos.global_position
		newBullet.global_rotation = shootPos.global_rotation
		var bulletSpread = I.spread
		newBullet.global_rotation.y += deg_to_rad(randf_range(-bulletSpread,bulletSpread))
		newBullet.scale = lerp(Vector3(I.size,I.size,I.size),Vector3.ONE,0.5)
		newBullet.speed = I.speed

func _resetCooldown():
	canFire = true
