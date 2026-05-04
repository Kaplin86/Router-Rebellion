extends Label3D
@export var dummyEnemy : BaseEnemy

var sinceLastSecond = 0.0
var damageLast = 0.0
func _process(delta):
	sinceLastSecond += delta
	if sinceLastSecond > 1:
		sinceLastSecond = 0
		var difference = damageLast - dummyEnemy.hp
		damageLast = dummyEnemy.hp
		text = str(difference)
		print(dummyEnemy.hp)
