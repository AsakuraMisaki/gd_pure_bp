extends Panel

onready var tree:Tree = get_node("Tree")
onready var search:LineEdit = get_node("search")

# Called when the node enters the scene tree for the first time.
func _ready():
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
	for name in targetobj.keys():
		var items:Dictionary = targetobj[name]
		var second = tree.create_item(root)
		second.set_text(0, name)
		for name1 in targetobj.keys():
			var trd = tree.create_item(second)
			trd.set_text(0, name1)
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
	reg.compile(text)
	for item in obj:
		for data in item:
			var searched = reg.search(data.name)
			if(!searched):
				pass
		# 	# search = reg.search(item.description)
			elif(searched):
				var parent = targetobj.get(item.parent, {})
				parent[data.name] = data
				targetobj[item.parent] = parent
		# pass
	return targetobj
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_search_text_changed(new_text:String):
	_refresh(new_text)
	pass # Replace with function body.
