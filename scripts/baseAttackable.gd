extends CharacterBody3D
class_name BaseAttackable

@export var Hp = 20
@export var MaxHp = 20
@export var team : int

@export_category("nodes")
@export var animationPlayer : AnimationPlayer

func playAnimation(animationName):
	if animationPlayer:
		if animationPlayer.has_animation(animationName):
			animationPlayer.play(animationName)

func takeDamage(damage : float, bullet : BulletPayload = null):
	Hp -= damage
