extends GraphEdit


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(Resource) var nodeSource

# Called when the node enters the scene tree for the first time.
func _ready():
	var list = nodeSource.instance()
	#self.add_child(list)
	
	#var nn = GraphNode.new()
	
	
	var node1 = list.get_node('GraphNode')
	var node2 = node1.duplicate(8)
	self.add_child(node2)
	#print(node1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
