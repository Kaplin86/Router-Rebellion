extends Node

@export var shootPos : Node3D
@export var cooldownTime = 0.2
@export var spread = 15
@export var maxFireSize = 1.5

@onready var cooldown = Timer.new()
@onready var baseBullet = preload("res://scenes/bullet.tscn")


var plyr : PlayerCharacter
var canFire = true


func _ready():
	add_child(cooldown)
	cooldown.wait_time = cooldownTime
	cooldown.one_shot = true
	cooldown.timeout.connect(_resetCooldown)
	
	
	plyr = get_parent()



func _process(delta):
	if canFire:
		if Input.is_action_pressed("shoot"):
			var payload = BulletPayload.new()
			var value : Array[BulletPayload] = References.runFactorySave(References.currentFactorySave,payload)
			
			value = getFinalPayloads(value)
			shoot(value)

func getFinalPayloads(bullets: Array[BulletPayload]):

	return bullets

func shoot(bullets: Array[BulletPayload]):
	plyr.uiManager.addStatus("Hi" + str(randi()))
	canFire = false
	cooldown.start()
	for I in bullets:
		var newBullet : BulletObject = baseBullet.instantiate()
		newBullet.team = plyr.team
		get_parent().add_sibling(newBullet)
		newBullet.global_position = shootPos.global_position
		newBullet.global_position.y += 0.2
		newBullet.global_rotation = shootPos.global_rotation
		var bulletSpread = I.spread
		newBullet.global_rotation.y += deg_to_rad(randf_range(-bulletSpread,bulletSpread))
		newBullet.scale = lerp(Vector3(I.size,I.size,I.size),Vector3.ONE,0.5)
		newBullet.payload = I


func _resetCooldown():
	canFire = true
