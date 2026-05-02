extends Control

@export var save : FactorySave
@export var graph : GraphEdit

var baseNode = preload("res://scenes/factory/factoryNode.tscn")


var selectedNode : GraphElement = null
var resourceToNodes : Dictionary[FactoryNode,GraphNode] = {}

var startSelectPos = Vector2.ZERO
var lastDragConnectionSource = null

var protectedTypes = ["inventory","output"]


func _ready():
	loadSave()
	fillPopup()

func fillPopup():
	$PopupMenu.clear()
	for I in References.factoryTypeToResource.keys():
		$PopupMenu.add_item(I)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("delete"):
		var currentSelectedNodes = []
		for I : GraphNode in resourceToNodes.values():
			if I.selected:
				currentSelectedNodes.append(I)
		
		for delNode : GraphNode in currentSelectedNodes:
			var resource : FactoryNode = resourceToNodes.find_key(delNode)
			print("tryuing to delete", resource)
			if resource.canDelete:
				
				delNode.queue_free()
				resourceToNodes.erase(resource)
				save.nodes.erase(resource)
				save.nodePositions.erase(resource)
				save.nodeConnections.erase(resource)
				for I in save.nodeConnections:
					if save.nodeConnections[I].has(resource):
						save.nodeConnections[I].erase(resource)
	print(save.nodes)

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
	
	
	newNode.title = I.type
	newNode.get_titlebar_hbox().get_child(0).horizontal_alignment = 1
	newNode.size = Vector2(376,168)
	newNode.get_child(-1).text = I.description
	
	if I.maxOutCount == 0:
		newNode.set_slot_enabled_right(0,false)
	if !I.canGetInput:
		newNode.set_slot_enabled_left(0,false)


func onNodeDrag(node : GraphElement):
	var resource : FactoryNode = resourceToNodes.find_key(node)
	save.nodePositions[resource] = node.position_offset


func _on_graph_edit_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	
	var fromResource = resourceToNodes.find_key(graph.get_node(str(from_node)))
	var toResource = resourceToNodes.find_key(graph.get_node(str(to_node)))
	if !save.nodeConnections.has(fromResource):
		save.nodeConnections[fromResource] = []
	save.nodeConnections[fromResource].append(toResource)
	renderConnections()


func _on_graph_edit_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	var fromResource = resourceToNodes.find_key(graph.get_node(str(from_node)))
	var toResource = resourceToNodes.find_key(graph.get_node(str(to_node)))
	
	if save.nodeConnections.has(fromResource):
		save.nodeConnections[fromResource].erase(toResource)
	renderConnections()


func _on_graph_edit_connection_from_empty(to_node: StringName, to_port: int, release_position: Vector2) -> void:
	#var toResource = resourceToNodes.find_key(graph.get_node(str(to_node)))
	#$PopupMenu.visible = true
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
		var newNode = References.createNewFactoryNodeFromType($PopupMenu.get_item_text(result))
		save.nodes.append(newNode)
		save.nodePositions[newNode] = release_position
		createNodeFromResource(newNode)
		var node = resourceToNodes[newNode]
		node.position_offset = save.nodePositions[newNode]
		_on_graph_edit_connection_request(graph.get_node(str(from_node)).name,0,node.name,0)
	
	newPopup.queue_free()


func _on_button_pressed() -> void:
	ResourceSaver.save(save,"user://factorySave.tres")
