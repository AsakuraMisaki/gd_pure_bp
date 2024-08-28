extends Panel

onready var tree:Tree = get_node("Tree")
onready var search:LineEdit = get_node("search")

signal node_created

func _input(event):
	
	if(event.is_action_pressed("add_graph_node")):
		var item:TreeItem = tree.get_selected()
		if(!item): return
		# var gr:Rect2 = tree.get_global_rect()
		# var area:Rect2 = tree.get_item_area_rect(item)
		# var a2:Rect2 = Rect2(gr.position + area.position, area.size)
		# var tarRec:Rect2 = gr.clip(a2)
		# prints(gr, a2, tarRec)
		# prints(tarRec.has_point(event.position))
	else:
		pass
		# var item:TreeItem = tree.get_next_selected(null)
		# print_debug(item)
	
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	tree.connect("item_activated", self, "_on_Tree_item_activated")
	tree.ensure_cursor_is_visible()
	var root = tree.create_item()
	root.set_text(0, "root")
	var child1 = tree.create_item(root)
	pass # Replace with function body.

func _refresh(text:String):
	var obj:Dictionary = PackedEnv.contextDic
	var targetobj:Dictionary = dofilter(text)
	tree.clear()
	var root = tree.create_item()
	root.set_text(0, "root")
	for name in targetobj:
		var items:Dictionary = targetobj[name]
		var second = tree.create_item(root)
		second.set_text(0, name)
		for name1 in items:
			var trd = tree.create_item(second)
			trd.set_text(0, name1)
			trd.set_meta("context", items[name1])
		pass	
	pass

func _dofilter(reg:RegEx, children:Array, targetobj:Dictionary):
	for item in children:
		if(reg.search(item.name)):
			var parent = targetobj.get(item.parent, {})


		pass
	return 

func dofilter(text:String) -> Dictionary:
	var obj:Dictionary = PackedEnv.contextDic
	if(!text.length()): return obj
	var targetobj:Dictionary = {}
	var reg = RegEx.new()
	reg.compile("(?i)" + text)
	for name in obj:
		var item:Dictionary = obj[name]
		# print_debug(item)
		for name1 in item:
			var data:Dictionary = item[name1]
			var searched = reg.search(data.name)
			if(!searched):
				pass
		# 	# search = reg.search(item.description)
			elif(searched):
				print_debug(searched.to_string())
				var parent = targetobj.get(data.parent, {})
				parent[data.name] = data
				targetobj[data.parent] = parent
		# pass
	return targetobj
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_search_text_changed(new_text:String):
	_refresh(new_text)
	pass # Replace with function body.


func _on_Tree_item_activated():
	var item:TreeItem = tree.get_selected()
	print_debug(item)
	var context:Dictionary = item.get_meta("context")
	if(context):
		var node:GraphNode = PackedEnv._makeGraphNode(context)
		emit_signal("node_created", node)
	# print_debug()
	pass # Replace with function body.
