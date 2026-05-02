extends Control

@export var save : FactorySave
@export var graph : GraphEdit
@export var drawline : Line2D

var baseNode = preload("res://scenes/factory/factoryNode.tscn")


var selectedNode : GraphElement = null
var resourceToNodes : Dictionary[FactoryNode,GraphElement] = {}

var startSelectPos = Vector2.ZERO


var connectionLines = []

func loadSave():
	for I in save.nodes:
		var newNode : GraphElement= baseNode.instantiate()
		resourceToNodes[I] = newNode
		graph.add_child(newNode)
		
		newNode.position_offset_changed.connect(onNodeDrag.bind(newNode))
		
	for I in save.nodePositions:
		if resourceToNodes.has(I):
			var node = resourceToNodes[I]
			node.position_offset = save.nodePositions[I]
			

func _process(delta):
	for I in connectionLines:
		I.queue_free()
	connectionLines.clear()
	
	for I in save.nodeConnections:
		print("connections are", save.nodeConnections[I])
		drawLine(I,save.nodeConnections[I])
	
	if selectedNode and Input.is_action_pressed("line"):
		drawLineToMouse(selectedNode)
		drawline.visible = true
	else:
		drawline.visible = false

func _ready():
	loadSave()

func onNodeDrag(node : GraphElement):
	var resource : FactoryNode = resourceToNodes.find_key(node)
	save.nodePositions[resource] = node.position_offset

func select(node):
	selectedNode = node
	selectedNode.modulate = Color.RED
	
	startSelectPos = selectedNode.global_position - get_global_mouse_position()
	
func deselect(node):
	if node == selectedNode:
		selectedNode.modulate = Color.WHITE
		selectedNode = null

func drawLineToMouse(startingNode : GraphElement):
	drawline.points[0] = startingNode.global_position - startSelectPos
	drawline.points[1] = get_global_mouse_position()

func drawLine(RootNode : FactoryNode, connectedNode : Array):
	for I in connectedNode:
		var newLine = Line2D.new()
		var node1 = resourceToNodes[RootNode]
		var node2 = resourceToNodes[I]
		add_child(newLine)
		newLine.add_point(node1.global_position)
		newLine.add_point(node2.global_position)
		connectionLines.append(newLine)
