extends MyEdit

export(Resource) var res_node

var nodeSource: Node
var selects:Array = Array()

# Called when the node enters the scene tree for the first time.
func _ready():
	nodeSource = res_node.instance()
	
	var list = nodeSource.get_children()

	for item in list:
		var pos = item.get_position()
		var newNode = item.duplicate(8)
		newNode.set_offset(Vector2(pos))
		self.add_child(newNode)

	# prints(PGL)
	# var nodeList = nodeSource.get_node('GraphNode')

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass



