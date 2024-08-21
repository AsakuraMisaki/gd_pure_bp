extends GraphEdit


export(Resource) var res_node

var nodeSource: Node
var selects = []

# Called when the node enters the scene tree for the first time.
func _ready():
	nodeSource = res_node.instance()
	
	var list = nodeSource.get_children()

	for item in list:
		var pos = item.get_position()
		var newNode = item.duplicate(8)
		newNode.set_offset(Vector2(pos))
		self.add_child(newNode)
		pass
	# var nodeList = nodeSource.get_node('GraphNode')

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Nodes_copy_nodes_request():
	pass # Replace with function body.


func _on_Nodes_node_unselected(node:Node):
	selects.erase(node)
	pass # Replace with function body.


func _on_Nodes_node_selected(node:Node):
	selects.append(node)
	pass # Replace with function body.
