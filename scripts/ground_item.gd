extends Node3D

@export var Item : BulletPayload
@export var Count := 1

var given = false

func _on_area_3d_body_entered(body):
	if given:
		return
	if body is PlayerCharacter:
		given = true
		for I in Count:
			body.attemptToGetItem(Item)
		#process_mode = Node.PROCESS_MODE_DISABLED
		queue_free()
	pass # Replace with function body.

func _ready():
	var texture : Texture2D = References.loadTextureFromPath("res://sprites/item/" + Item.visualType)
	if texture:
		var img = texture.get_image()
		img.resize(128,128)
	$Sprite3D.texture = texture
