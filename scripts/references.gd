extends Node

var currentFactorySave : FactorySave

var factoryNodePaths = [
	"res://data/factoryNodes/baseRefiner.tres",
	"res://data/factoryNodes/baseSplitter.tres",
	"res://data/factoryNodes/imbalanceSplitter.tres",
	"res://data/factoryNodes/strongRefiner.tres",
	"res://data/factoryNodes/accelerator.tres",
	"res://data/factoryNodes/balancer.tres",
	"res://data/factoryNodes/grower.tres"
	
	
	
]



var factoryTypeToResource : Dictionary[String,FactoryNode]= {}

func _ready() -> void:
	setupFactoryNodeDefinitions()
	print(factoryTypeToResource)
	loadFactoryFromFile()

func loadFactoryFromFile():
	var filePath = ProjectSettings.globalize_path("user://factorySave.tres")
	if FileAccess.file_exists(filePath):
		var resource = ResourceLoader.load(filePath)
		currentFactorySave = resource.duplicate(true)
	else:
		var resource = load("res://data/startingFactory.tres")
		currentFactorySave = resource.duplicate(true)


func setupFactoryNodeDefinitions():
	for I in factoryNodePaths:
		var resource : FactoryNode = load(I)
		factoryTypeToResource[resource.type] = resource

func createNewFactoryNodeFromType(type : String):
	if factoryTypeToResource.has(type):
		return factoryTypeToResource[type].duplicate()
	return null

var finalBullets : Array[BulletPayload] = []
func runFactorySave(save : FactorySave, input : BulletPayload):
	finalBullets.clear()
	var startingNode : FactoryNode = null
	for I in save.nodes:
		if I.type == "Inventory":
			startingNode = I
			break
	
	if startingNode:
		recursiveProcessing(startingNode,input,0, save)
		
	return finalBullets

func recursiveProcessing(node : FactoryNode, payload : BulletPayload, depth: int, save : FactorySave):
	if depth > 25: return
	 
	var results = node.apply_effect(payload) #this transfomrs the payload from the perspective of the factory node
	
	var connections = save.nodeConnections.get(node, [])
	
	if node.type == "Output":
		finalBullets.append_array(results)
		return
	
	if connections == []:
		return
	
	for item in results:
		var next = connections.pick_random()
		recursiveProcessing(next, item.duplicate(), depth + 1,save)
