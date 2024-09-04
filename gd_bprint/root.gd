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
onready var load_btn:Button = get_node("load")

export(Theme) var key_theme:Theme
export(Resource) var env:Resource
export(PackedScene) var r_popmenu:PackedScene 
export(PackedScene) var r_basic:PackedScene 
export(String) var duplicate_scene_path:String
export(String) var saver:String
export(String) var jser:String
onready var saver_reader = File.new()
onready var sfile_ok:int = saver_reader.open(saver, File.READ_WRITE)
onready var save_data = PGL.yaml.parse(saver_reader.get_as_text())
onready var jser_reader = File.new()
onready var jfile_ok:int = jser_reader.open(jser, File.READ_WRITE)



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
	# editor.connect("connection_to_empty", self, "on_connection_to_empty")
	run_btn.connect("button_down", self, "run")
	save_btn.connect("button_down", self, "save")
	load_btn.connect("button_down", self, "load")
	_setup_entry()
	# _readyBasic()
	pass # Replace with function body.


func _create_ports(name:String)->Node:
	var port:Control = basic.get_node("ports/"+name)
	return port.duplicate()

func _setup_entry():
	var point = Vector2(100, 100)
	var node:GraphNode = _create_node_common(PackedEnv.contextDic.main.__ENTRY, "__ENTRY", {}, "__ENTRY", point)
	editor.add_child(node)
	editor.set_meta("entry", node)
	pass

func on_popmenu_node_created(ctx:Dictionary, item:TreeItem):
	print_debug(ctx)
	var name:String = item.get_text(0)
	var flow_ctx:Dictionary = Dictionary()
	var __id = Time.get_ticks_msec()
	var vp:Viewport = get_viewport()
	var point:Vector2 = vp.get_mouse_position()
	var node:GraphNode = _create_node_common(ctx, __id, flow_ctx, name, point)
	editor.add_child(node)
	
	pass

func _create_node_common(ctx, id, node_ctx, title, point)->GraphNode:
	var node:GraphNode = _create_ports("graph")
	for key in ctx:
		var item1 = ctx[key]
		print_debug(item1)
		var path = item1.type
		var sid:int = item1.slot
		var slot:Control = _create_ports(path)
		if(item1.has("u_source")):
			var u_source = item1.u_source
			process_u_source(slot, u_source, sid)
		var ctx_item = item1.duplicate()
		ctx_item.__key = key
		node_ctx[key] = ctx_item
		slot.set_meta("ctx", ctx_item)
		node.add_child(slot)
		var i = slot.get_index()
		node.set_slot(i, (sid == 0 || sid == 2), 0, 0xffffff, (sid == 1 || sid == 2 ), 0, 0xff00ff)
		pass
	node.set_meta("__id", id)
	node.set_meta("ctx", node_ctx)
	node.set_offset(point)
	node.theme = key_theme
	node.title = title
	node.name = title
	# node.owner = editor
	return node

func create_node_by_saved(data:Dictionary, title:String)->GraphNode:
	var point = Vector2(data.offset[0], data.offset[1])
	var node = _create_node_common(data.ctx, data.__id, { }, title, point)
	editor.add_child(node)
	return node
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
	# if(event.is_action("popmenu_request")):
	# 	var vp:Viewport = get_viewport()
	# 	var point:Vector2 = vp.get_mouse_position()
	# 	popmenu.set_position(point)
	# 	if(!(self.get_children().has(popmenu))):
	# 		self.add_child(popmenu)
	pass

func _popmenu_request(point:Vector2):
	popmenu.set_position(point)
	if(!(self.get_children().has(popmenu))):
		self.add_child(popmenu)
	else:
		self.remove_child(popmenu)
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
	var children = editor.get_children()
	var targets = {}
	for node in children:
		if(!(node is GraphNode)): continue
		var id = node.get_meta("__id")
		var title = node.title
		var offset = node.get_offset()
		offset = [offset.x, offset.y]
		var ctx = node.get_meta("ctx")
		targets[id] = { "title":title, "offset":offset, "ctx":ctx, "__id":id }
		pass
	var uid = Time.get_datetime_string_from_system()
	var saved = {uid:targets}
	var result = PGL.yaml.print(saved)
	print_debug(result)
	var _pre = saver_reader.get_as_text()
	_pre += result + "\n"
	saver_reader.store_string(result + "\n")
	saver_reader.flush()
	pass

func load():
	save_data = PGL.yaml.parse(saver_reader.get_as_text()).result
	print_debug(save_data)
	
	for name in save_data:
		var temp = Dictionary()
		var data = save_data[name]
		for id in data:
			var item = data[id]
			var node:GraphNode = create_node_by_saved(item, item.title)
			temp[id] = node
			node.name = id
			# print_debug(temp)
			pass
		# print_debug(temp["16018"])
		for id1 in temp:
			var g_node = temp[id1]
			var name_from = g_node.name
			var children = g_node.get_children()
			for slot in children:
				var ctx = slot.get_meta("ctx")
				var __to = ctx.get("__to", null)
				var flow_id = ctx.flow
				var temp1 = funcref(self, "_finder")
				var _children = editor._array_filter(children, temp1, {"flow_id":flow_id})
				var slot_from = _children.find(slot)
				if(__to):
					var ptr_to0 = __to[0]
					# print_debug(temp["16018"], temp, __to[0])
					var toer = temp[String(ptr_to0)]
					var name_to = toer.name
					var slot_to = __to[2]
					if(ctx.flow == 0):
						editor.connect_node(name_to, slot_to, name_from, slot_from)
					else:
						editor.connect_node(name_from, slot_from, name_to, slot_to)
				pass
			pass
		# temp.clear()
		pass
	
	pass

static func _finder(item, options):
	var ctx = item.get_meta("ctx") 
	if(ctx.flow == 2 || ctx.flow == options.flow_id):
		return true
	return false

func _load(targets:Array):
	
	pass

func run():
	_exec_ctx_text(PGL.current.get_child(0))
	# var return_node:GraphNode = _find_entry()
	# print_debug(editor.connection)
	# print_debug(return_node)
	# if(!return_node):
	# 	print_debug("run invaild")
	# 	return
	# _run(return_node)
	pass

func _run(node:GraphNode):
	

	pass

func _exec_ctx_text(slot0:Control):
	# $i_arr.forEach((item, i)=>{$f_body});
	var _ctx = slot0.get_meta("ctx")
	print_debug(_ctx)
	var text = "$f_"
	if(_ctx.has("ctx")):
		var text1 = _ctx.ctx
		text = text1 + text
	
	# var text1 = _ctx.ctx
	# var text = text1 + "$f_"
	print_debug(text)
	jser_reader.store_string(text + '\t')
	jser_reader.flush()
	var node = slot0.get_parent()
	var deep_execes = RegEx.new()
	deep_execes.compile("\\$[a-z_]+")
	var ctx_keys = node.get_meta("ctx").keys()
	var results = deep_execes.search_all(text)
	for re in results:
		var _name = re.get_string()
		_name = _name.replace("$", "")
		var i = ctx_keys.find(_name)
		if(i < 0):
			continue
		var slot:Control = node.get_child(i)
		var ctx = slot.get_meta("ctx")
		var txt
		if(ctx.has("__to")):
			var t_id = ctx.__to[0]
			var index = ctx.__to[2]
			var t_node = editor.get_node(String(t_id))
			var children = t_node.get_children()
			var temp1 = funcref(self, "_finder")
			var t_slot = editor._array_filter(children, temp1, { "flow_id":1 })
			_exec_ctx_text(t_slot[index])
		elif(slot is Label):
			txt = slot.text
			print_debug(txt)
			jser_reader.store_string(String(txt) + "\t")
			jser_reader.flush()
		elif(slot is OptionButton):
			txt = slot.get_item_text(slot.selected)
			print_debug(txt)
			jser_reader.store_string(String(txt) + "\t")
			jser_reader.flush()
		elif(slot is SpinBox):
			txt = slot.get_line_edit().text
			print_debug(txt)
			jser_reader.store_string(String(txt) + "\t")
			jser_reader.flush()
		elif((slot is LineEdit) || (slot is TextEdit)):
			txt = slot.text
			print_debug(slot.text)
			jser_reader.store_string(String(txt) + "\t")
			jser_reader.flush()
		pass
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



