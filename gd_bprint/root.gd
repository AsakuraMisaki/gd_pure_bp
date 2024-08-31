signal copy
signal paste
signal select
signal un_select

extends MyEdit

onready var tab:TabContainer = get_node("work/TabContainer")
onready var debuger:RichTextLabel = get_node("work/HBoxContainer/debug")
onready var editor:GraphEdit = get_node("work/TabContainer/GraphEdit")
onready var run_btn:Button = get_node("run")
onready var save_btn:Button = get_node("save")

export(Theme) var key_theme:Theme
export(Resource) var env:Resource
export(PackedScene) var r_popmenu:PackedScene 
export(PackedScene) var r_basic:PackedScene 
export(String) var duplicate_scene_path:String
export(PackedScene) var saver:PackedScene

onready var popmenu:Node = r_popmenu.instance()
onready var basic:Node = r_basic.instance()
# var entry:GraphNode
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var debug_mes = "\n \t {mes}"


# Called when the node enters the scene tree for the first time.
func _ready():
	popmenu.connect("node_created", self, "on_popmenu_node_created")
	run_btn.connect("button_down", self, "run")
	save_btn.connect("button_down", self, "save")
	# _readyBasic()
	pass # Replace with function body.


func _create_ports(name:String)->Node:
	var port:Control = basic.get_node("ports/"+name)
	return port.duplicate()

func on_popmenu_node_created(ctx:Dictionary, item:TreeItem):
	print_debug(ctx)
	var name:String = item.get_text(0)
	var node:GraphNode = _create_ports("graph")
	node.title = name
	node.name = name
	# var basic_ctx = PackedEnv.basic
	var flow_ctx:Dictionary = Dictionary()
	for key in ctx:
		var item1 = ctx[key]
		print_debug(item1)
		var path = item1.type
		var sid:int = item1.slot
		var slot:Control = _create_ports(path)
		if(item1.has("u_source")):
			var u_source = item1.u_source
			process_u_source(slot, u_source, sid)
		var sep = _create_ports("sep")
		slot.set_meta("ctx", item1)
		slot.set_meta("ctx_key", key)
		slot.set_meta("connection", {0:[], 1:[]})
		node.add_child(slot)
		flow_ctx[key] = slot
		var i:int = slot.get_index()
		print_debug(i)
		slot.set_meta("slot_type", i)
		node.set_slot(i, (sid == 0 || sid == 2), 0, 0xffffff, (sid == 1 || sid == 2 ), 0, 0xff00ff)
		# node.add_child(sep)
		sep.set_size(Vector2(0, 4))
		pass
	var vp:Viewport = get_viewport()
	var point:Vector2 = vp.get_mouse_position()
	node.theme = key_theme
	node.set_offset(point)
	editor.add_child(node)
	node.set_meta("ctx", flow_ctx)
	node.owner = editor
	pass

func process_u_source(slot:Control, u_source, sid:int):
	if(slot is Label):
		slot.text = u_source
		if(sid == 1):
			slot.align = 2
	elif(slot is OptionButton):
		for name in u_source:
			slot.add_item(name)
			pass


func _input(event):
	if(event.is_action("popmenu_request")):
		var vp:Viewport = get_viewport()
		var point:Vector2 = vp.get_mouse_position()
		popmenu.set_position(point)
		if(!(self.get_children().has(popmenu))):
			self.add_child(popmenu)
	pass

func _process(delta):
	if(PGL.debugs.size()):
		write_debug(PGL.debugs.pop_front())
	# prints(PGL.selecteds.size(), PGL.selecteds)
	pass

func _on_copy_nodes_request():
	._copy_nodes_request()
	pass

func _on_paste_nodes_request():
	var edit:GraphEdit = tab.get_current_tab_control()
	._paste_nodes_request(edit)
	pass

func _on_node_selected(node:Node):
	._selected(node)
	# editor._get_code(node)
	var children:Array = node.get_children()
	print_debug(node.name.match("return"))
	for item in children:
		if(item.has_meta("ctx")):
			var ctx = item.get_meta("ctx")
			print_debug(ctx)
		if(item.has_meta("slot_type")):
			var type = item.get_meta("slot_type")
			print_debug(type)
		pass
	# if(node == entry):
	# 	print_debug("entry selected:", node)
	pass 

func _on_node_unselected(node:Node):
	._unselected(node)
	pass

func _on_node_delete(node:Node):
	var edit:GraphEdit = tab.get_current_tab_control()
	._node_delete(edit, node)
	pass

func write_debug(mes:String):
	debuger.add_text(debug_mes.format({"mes":mes}))
	pass


func save():
	var current_scene = editor
	if current_scene:
			# 创建场景的副本
			var name = current_scene.get_name()
			var FLAG = DUPLICATE_USE_INSTANCING
			var node = current_scene.duplicate(FLAG)
			var scene = PackedScene.new()
			# 现在只有 `node` 和 `rigid` 被打包。
			var result = scene.pack(node)
			if result == OK:
				var error = ResourceSaver.save("res://res/"+ name + ".scn", scene)  # 或者 "user://..."
				if error != OK:
						push_error("保存场景到磁盘时发生错误。")
	pass

func run():
	var return_node:GraphNode = _find_entry()
	print_debug(editor.connection)
	print_debug(return_node)
	if(!return_node):
		print_debug("run invaild")
		return
	# _run(return_node)
	pass

func _run(node:GraphNode):
	var connection:Dictionary = editor.connection
	# print_debug(node.get_meta("ctx"))
	var flow_ctx:Dictionary = node.get_meta("ctx")
	if(!flow_ctx): return
	var has:bool = flow_ctx.has("f_")
	for key in flow_ctx:
		var _node:GraphNode = flow_ctx[key]
		var connect_id = node.name + String(_node.get_index())
		if(connection.has(connect_id)):
			var arr:Array = connection[connect_id]
			for ids in arr:

				pass
		pass
	# if(has):
	# 	var slot:Control = flow_ctx.f_
	# 	var i = slot.get_index()

	# 	pass

	pass

func _find_entry():
	var children:Array = editor.get_children()
	var entry = null
	for node in children:
		if(!node.name.match("return")): continue
		var flow = node.get_meta("ctx")
		print_debug(flow)
		var _f:Control = flow.f_
		if(!_f): continue
		var connection = _f.get_meta("connection")[0]
		for slot in connection:
			if(slot.get_meta("ctx_key") == "f_"):
				entry = _f
				break
		pass
	if(!entry): return
	return __find_entry(entry)
	pass

func __find_entry(entry_slot):
	var connection = entry_slot.get_meta("connection")[0]
	if(!connection.size()):
		var node:GraphNode = entry_slot.get_parent()
		# print_debug(node.theme)
		node.selected = true
		# node.theme = key_theme
		return node
	for slot in connection:
		if(slot.get_meta("ctx_key") == "f_"):
			# var temp = self.get_meta("temp_node", Node.new())
			# temp.theme = null
			var temp_node:GraphNode = slot.get_parent()
			# temp_node.theme = key_theme
			# self.set_meta("temp_node", temp_node)
			return __find_entry(slot)
		pass
	pass



