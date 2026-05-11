extends CharacterBody3D
class_name BaseAttackable

var statuses : Array[BaseStatusEffect] = []

@export var Hp = 20
@export var MaxHp = 20
@export var team : int

@export_category("influences")
@export var base_accuracy = 1 #only effects ranged
@export var base_movementSpeed = 50
@export var base_attackSpeed = 0.6
@export var base_damage = 5
@export var randomDamageFactor = 0.15

var stunned = false
var movementSpeed = 0
var accuracy = 0
var damage = 0
var attackSpeed = 0


@export_category("nodes")
@export var animationPlayer : AnimationPlayer

func _process(delta):
	runStatus() #note to self: DO NOT RUN THIS EVERY FRAME IN THE FUTURE

func runStatus():
	#reset
	accuracy = base_accuracy
	movementSpeed = base_movementSpeed
	attackSpeed = base_attackSpeed
	damage = base_damage
	stunned = false
	
	for I : BaseStatusEffect in statuses:
		var effects = I.get_stat_changes()
		for E in effects:
			var mult = false
			var value = effects[E]
			if E.ends_with("_MULT"):
				E = E.replace("_MULT","")
				mult = true
			if E in self:
				if mult:
					set(E,get(E) * value)
				else:
					set(E,get(E) + value)
	

func playAnimation(animationName):
	if animationPlayer:
		if animationPlayer.has_animation(animationName):
			animationPlayer.play(animationName)

func takeDamage(damage : float, bullet : BulletPayload = null):
	Hp -= damage
