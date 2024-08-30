extends GraphEdit

export(Script) var res_builder

var selects:Array = Array()
var caches:Dictionary = Dictionary()

# var textt:String = "#slot:0"

# Called when the node enters the scene tree for the first time.
func _ready():
	# JSON.parse(textt)
	pass 

func _process(delta):
	# updateSourceSignl()
	pass

func updateSourceSignl():
	pass

func _on_GraphEdit_connection_request(from:String, from_slot:int, to:String, to_slot:int):
	prints(from, from_slot, to, to_slot)
	var result:int = .connect_node(from, from_slot, to, to_slot)
	
	pass 




func _on_GraphEdit_disconnection_request(from:String, from_slot:int, to:String, to_slot:int):
	.disconnect_node(from, from_slot, to, to_slot)
	pass # Replace with function body.

func _get_code(node:GraphNode):
	print_debug(node)
	var children:Array = node.get_children()
	for item in children:
		if(!item.has_meta("type")): continue
		var tt = item.get_meta("type")
		var i:int = item.get_index()
		match tt:
			"flow":

				pass
			"return":
				pass
			"param":
				pass
		pass
	pass