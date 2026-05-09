extends BaseAttackable
class_name PlayerCharacter

@export var playerSpeed : float = 6
@export var drag : float = 2

@export var uiManager : UiManager

@export var inventory : Dictionary[int,Dictionary] = {}


func _process(delta):
	var inputLR = Input.get_axis("east","west")
	var inputUD = Input.get_axis("north","south")
	
	impulse(Vector3(inputUD,0,inputLR))
	move_and_slide()
	runDrag(delta)
	
	turnToMouse()

func impulse(movement : Vector3):
	velocity += movement

func runDrag(delta):
	var newVelocity = Vector3(0,velocity.y -0.01,0)
	velocity = lerp(velocity,newVelocity,delta * drag)

func turnToMouse():
	var mousePos = get_viewport().get_mouse_position()
	var camera = get_viewport().get_camera_3d()
	
	var dropPlane  = Plane(Vector3(0, 1,0), global_position.y)
	var position3D = dropPlane.intersects_ray(camera.project_ray_origin(mousePos),camera.project_ray_normal(mousePos))
	
	if position3D:
		var newPosition = Vector3(position3D.x,global_position.y,position3D.z)
		look_at(newPosition)

func attemptToGetItem(item : BulletPayload):
	for I in inventory:
		var data = inventory[I]
		if item.is_equal(data.get("item",null)):
			data["count"] += 1
			return true
	
	var index = inventory.size()
	inventory[index] = {"item":item,"count":1}

func retrieveItemFromInventory():
	if inventory.get(0,null):
		var data = inventory[0]
		var resource = data.get("item",null)
		data["count"] -= 1
		validateInventory()
		print("returning", resource)
		return resource
	else:
		return null

func validateInventory():
	var newOrder = []
	var nums = inventory.keys()
	nums.sort()
	for I in nums:
		var data = inventory[I]
		if data["count"] > 0:
			newOrder.append(data)
	
	var counter = 0
	inventory.clear()
	for I in newOrder:
		inventory[counter] = I
		counter += 1
	
