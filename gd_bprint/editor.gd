extends GraphEdit

export(Script) var res_builder

var selects:Array = Array()
var caches:Dictionary = Dictionary()
var connection:Dictionary = Dictionary()

# var textt:String = "#slot:0"

# Called when the node enters the scene tree for the first time.
func _ready():
	# .add_valid_connection_type(2, 0)
	# JSON.parse(textt)
	pass 

func _process(delta):
	# updateSourceSignl()
	pass

func updateSourceSignl():
	pass

func _on_GraphEdit_connection_request(from:String, from_slot:int, to:String, to_slot:int):
	
	var result:int = .connect_node(from, from_slot, to, to_slot)
	var slot_from:Control = self.get_node(from).get_child(from_slot)
	var slot_to:Control = self.get_node(to).get_child(to_slot)
	var ctx_from = slot_from.get_meta("ctx")
	var ctx_to = slot_to.get_meta("ctx")

	var output_id
	if(ctx_to.flow == 0):
		output_id = slot_from.get_parent().get_meta("__id")  
		ctx_to.__to = [output_id, from, from_slot]
	else:
		output_id = slot_to.get_parent().get_meta("__id")  
		ctx_from.__to = [output_id, to, to_slot]

	printt(ctx_to, ctx_from, from, from_slot, to, to_slot)
	# if(ctx_from.flow == 0 && ctx_to.flow == 1):
	# 	input = [from, from_slot]
	# 	output = [to, to_slot]
	# elif(ctx_to.flow == 0 && ctx_from.flow == 1):
	# 	input = [to, to_slot]
	# 	output = [from, from_slot]
	# elif(ctx_to.flow == 2 && ctx_from.flow == 2):
	# 	var view_port_rect = slot_to.get_viewport_rect()
	# 	var vp:Viewport = get_viewport()
	# 	var point:Vector2 = vp.get_mouse_position()
	# 	# print_debug(view_port_rect, point)
	# 	var m_x = point.x
	# 	var g_rect = slot_to.get_global_rect()
	# 	var center_x = slot_to.rect_global_position.x + g_rect.size.x / 2
	# 	var mp_local_to = m_x - center_x
	# 	printt(to, g_rect, center_x, m_x, mp_local_to)
	# 	# left
	# 	if(mp_local_to <= 0): 
	# 		input = [from, from_slot]
	# 		output = [to, to_slot]
	# 	# right
	# 	elif(mp_local_to > 0): 
	# 		input = [to, to_slot]
	# 		output = [from, from_slot]
	# if(input.size() && input[0] == to):
	# 	ctx_to.__to = output.duplicate() 
	# elif(input.size() && input[0] == from):
	# 	ctx_from.__to = output.duplicate() 
	# var connection_from = slot_from.get_meta("connection")
	# var connection_to = slot_to.get_meta("connection")
	# print_debug(from, from_slot, to, to_slot, connection_to, connection_from)
	# if(!connection_from[1].has(slot_to)):
	# 	connection_from[1].append(slot_to)
	# 	connection_to[0].append(slot_from)

	# var id_from:String = from + String(from_slot)
	# var id_to:String = to + String(to_slot)
	# _add_connection_cache(id_from, id_to)
	# _add_connection_cache(id_to, id_from)
	pass 

func _add_connection_cache(id_from:String, id_to:String):

	if(connection.has(id_from)):
		var arr:Array = connection.get(id_from)
		if(!arr.has(id_to)):
			arr.append(id_to)
	else:
		var arr1:Array = [id_to]
		connection[id_from] = arr1
	pass

func _remove_connection_cache(id_from:String, id_to:String):
	if(connection.has(id_from)):
		var arr:Array = connection.get(id_from)
		arr.erase(id_to)
	else:
		pass
	pass
# func is_valid_connection_type(from:int, to:int)->bool:
# 	if(to == 0):
# 		return true
# 	return (from == to)


func _on_GraphEdit_disconnection_request(from:String, from_slot:int, to:String, to_slot:int):
	.disconnect_node(from, from_slot, to, to_slot)
	# var slot_from = self.get_node(from).get_child(from_slot)
	# var slot_to = self.get_node(to).get_child(to_slot)
	# var connection_from = slot_from.get_meta("connection")
	# var connection_to = slot_to.get_meta("connection")
	# # if(!connection_from[1].has(slot_to)):
	# connection_from[1].erase(slot_to)
	# connection_to[0].erase(slot_from)

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