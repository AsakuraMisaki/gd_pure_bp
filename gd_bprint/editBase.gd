extends Node

class_name MyEdit

func _ready():
	pass # Replace with function body.

func _paste_nodes_request(tab:GraphEdit):
	var vp:Viewport = get_viewport()
	var point:Vector2 = vp.get_mouse_position()
	var offset:Array = [0, 0]
	var ox:int = 50
	var oy:int = 25
	for item in PGL.selecteds:
		item = item as GraphNode
		var newNode:GraphNode = item.duplicate(8)
		var v: Vector2 = Vector2(offset[0] + point.x, offset[1] + point.y)
		newNode.set_offset(v)
		newNode.remove_meta('id')
		tab.add_child(newNode)
		offset[0] += ox
		offset[1] += oy
		pass
	pass

func _copy_nodes_request():
	PGL.selecteds = PGL.selects.duplicate(false)
	print(PGL.selecteds)

func _unselected(node:Node):
	PGL.selects.erase(node)

func _selected(node:Node):
	var has:bool = PGL.selects.has(node)
	if(has): return
	# print(node.id)
	if (not(node.has_meta('id'))):
		node.set_meta('id', Time.get_ticks_msec())
	PGL.selects.append(node)
	PGL.current = node
	print(node.get_meta('id'))

func _node_delete(tab:GraphEdit, node:Node):
	tab.remove_child(node)
	pass
	
