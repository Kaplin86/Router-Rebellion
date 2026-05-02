extends Control

@export var save : FactorySave
@export var graph : GraphEdit

var baseNode = preload("res://scenes/factory/factoryNode.tscn")


var selectedNode : GraphElement = null
var resourceToNodes : Dictionary[FactoryNode,GraphElement] = {}

var startSelectPos = Vector2.ZERO
var lastDragConnectionSource = null



func loadSave():
	for I in save.nodes:
		createNodeFromResource(I)
		
	for I in save.nodePositions:
		if resourceToNodes.has(I):
			var node = resourceToNodes[I]
			node.position_offset = save.nodePositions[I]
	
	renderConnections()

func renderConnections():
	graph.clear_connections()
	for resource in save.nodeConnections:
		var node = resourceToNodes[resource]
		for I in save.nodeConnections[resource]:
			var node2 = resourceToNodes[I]
			graph.connect_node(node.name,0,node2.name,0,false)

func createNodeFromResource(I : FactoryNode):
	var newNode : GraphNode = baseNode.instantiate()
	resourceToNodes[I] = newNode
	graph.add_child(newNode)
	
	newNode.position_offset_changed.connect(onNodeDrag.bind(newNode))
	
	if I.type == "inventory":
		newNode.set_slot_enabled_left(0,false)
	if I.type == "output":
		newNode.set_slot_enabled_right(0,false)

func _ready():
	loadSave()

func onNodeDrag(node : GraphElement):
	var resource : FactoryNode = resourceToNodes.find_key(node)
	save.nodePositions[resource] = node.position_offset


func _on_graph_edit_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	
	var fromResource = resourceToNodes.find_key(graph.get_node(str(from_node)))
	var toResource = resourceToNodes.find_key(graph.get_node(str(to_node)))
	if !save.nodeConnections.has(fromResource):
		save.nodeConnections[fromResource] = []
	save.nodeConnections[fromResource].append(toResource)
	print("node connections are now", save.nodeConnections)
	renderConnections()


func _on_graph_edit_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	var fromResource = resourceToNodes.find_key(graph.get_node(str(from_node)))
	var toResource = resourceToNodes.find_key(graph.get_node(str(to_node)))
	
	if save.nodeConnections.has(fromResource):
		save.nodeConnections[fromResource].erase(toResource)
	renderConnections()


func _on_graph_edit_connection_from_empty(to_node: StringName, to_port: int, release_position: Vector2) -> void:
	var toResource = resourceToNodes.find_key(graph.get_node(str(to_node)))
	$PopupMenu.visible = true
	print("hi")
	#var newResource = FactoryNode.new()
	


func _on_graph_edit_connection_to_empty(from_node: StringName, from_port: int, release_position: Vector2) -> void:
	var fromResource = resourceToNodes.find_key(graph.get_node(str(from_node)))
	lastDragConnectionSource = fromResource
	var newPopup = $PopupMenu.duplicate()
	add_child(newPopup)
	newPopup.visible = true
	newPopup.position = get_global_mouse_position()
	var result = await newPopup.index_pressed
	
	if result is int:
		var newNode = FactoryNode.new()
		newNode.type = $PopupMenu.get_item_text(result)
		save.nodes.append(newNode)
		save.nodePositions[newNode] = release_position
		createNodeFromResource(newNode)
		var node = resourceToNodes[newNode]
		node.position_offset = save.nodePositions[newNode]
	
	newPopup.queue_free()
