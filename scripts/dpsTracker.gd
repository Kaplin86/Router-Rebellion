extends Label3D
@export var dummyEnemy : BaseEnemy

var sinceLastSecond = 0.0
var damageLast = 0.0
func _process(delta):
	sinceLastSecond += delta
	if dummyEnemy:
		if sinceLastSecond > 1:
			sinceLastSecond = 0
			var difference = damageLast - dummyEnemy.Hp
			damageLast = dummyEnemy.Hp
			text = str(difference)
