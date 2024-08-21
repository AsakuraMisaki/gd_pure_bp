extends GraphEdit

export(Script) var res_builder

var nodeSource: Node
var builder
var selected: GraphNode
var debug: RichTextLabel
var debugMes = "\n \t {mes}"

func editor_debug(mes:String):
	var mm = debugMes.format({'mes':mes})
	debug.add_text(mm)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	nodeSource = get_parent().get_node("Nodes")
	debug = get_parent().get_node("debug")
	debug.add_text("[debug log]")
	editor_debug("working")
	editor_debug("vesion .1")
	pass 

func _on_GraphEdit_copy_nodes_request():
	if(selected != null):
		print(selected)
		var newNode = selected.duplicate(8)
		var pos = selected.get_offset()
		prints(pos)
		selected.set_offset(Vector2(pos.x - 100, pos.y - 100))
		
		self.add_child(newNode)
		prints(newNode.get_offset())
	pass

func _process(delta):
	updateSourceSignl()
	pass

func updateSourceSignl():
	if(nodeSource == null): return 
	# if(nodeSource.selects.length <= 0): pass
	print(nodeSource.selects)

func _on_GraphEdit_node_selected(node):
	selected = node
	pass 


func _on_GraphEdit_connection_request(from:String, from_slot:int, to:String, to_slot:int):
	pass 
