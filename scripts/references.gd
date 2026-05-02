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
