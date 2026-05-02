extends Node

var factoryNodePaths = [
	"res://data/factoryNodes/baseRefiner.tres",
	"res://data/factoryNodes/baseSplitter.tres",
	"res://data/factoryNodes/imbalanceSplitter.tres",
	"res://data/factoryNodes/strongRefiner.tres"
]

var factoryTypeToResource : Dictionary[String,FactoryNode]= {}

func _ready() -> void:
	setupFactoryNodeDefinitions()
	print(factoryTypeToResource)

func setupFactoryNodeDefinitions():
	for I in factoryNodePaths:
		var resource : FactoryNode = load(I)
		factoryTypeToResource[resource.type] = resource

func createNewFactoryNodeFromType(type : String):
	if factoryTypeToResource.has(type):
		return factoryTypeToResource[type].duplicate()
	return null

var finalBullets = []
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
