extends Resource
class_name FactoryNode

@export_category("Metadata")
@export var type := ""
@export var settings := {}
@export_multiline var description := "A standard factory component."
@export var icon : Texture2D
@export_category("Connection Data")
@export var maxOutCount : int = 1
@export var canGetInput := true
@export var canDelete := true

func apply_effect(payload: BulletPayload) -> Array[BulletPayload]:
	return [payload]
