extends Resource
class_name FactorySave

@export var nodes : Array[FactoryNode] = []
@export var nodePositions : Dictionary[FactoryNode,Vector2] = {}
@export var nodeConnections : Dictionary[FactoryNode,Array] = {}
