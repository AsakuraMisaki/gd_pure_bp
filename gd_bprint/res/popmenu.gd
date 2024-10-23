extends Panel

onready var tree:Tree = get_node("Tree")
onready var search:LineEdit = get_node("search")

var contextDic:Dictionary

signal node_created

# Called when the node enters the scene tree for the first time.
func _ready():
	tree.connect("item_activated", self, "_on_Tree_item_activated")
	tree.ensure_cursor_is_visible()
	var root = tree.create_item()
	root.set_text(0, "root")
	var child1 = tree.create_item(root)
	pass # Replace with function body.

func _refresh(text:String):
	if(!contextDic):
		return
	var obj:Dictionary = contextDic
	var targetobj:Dictionary = dofilter(text)
	tree.clear()
	var root = tree.create_item()
	root.set_text(0, "root")
	var re:RegEx = RegEx.new()
	re.compile("^__")
	for name in targetobj:
		if(re.search(name) || (name.find("$") == 0)): 
			continue
		var items:Dictionary = targetobj[name]
		var second = tree.create_item(root)
		second.set_text(0, name)
		for name1 in items:
			if(re.search(name1)): continue
			var trd = tree.create_item(second)
			trd.set_text(0, name1)
			trd.set_meta("context", items[name1])
		pass	
	pass



func dofilter(text:String) -> Dictionary:
	var obj:Dictionary = contextDic
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
	var has:bool = item.has_meta("context")
	if(!has):
		return
	var context = item.get_meta("context")
	if(context):
		# var node:GraphNode = PackedEnv._makeGraphNode(context)
		emit_signal("node_created", context, item)
	# print_debug()
	pass # Replace with function body.
