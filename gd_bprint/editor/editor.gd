extends Node2D

export(Theme) var key_theme:Theme
export(PackedScene) var r_basic:PackedScene 
export(Array, String) var env_ex:Array
export(String) var env_0:String

var yaml = preload("res://addons/godot-yaml/gdyaml.gdns").new()

var copyed: Array = Array()
var selects: Array = Array()
var config: Dictionary = Dictionary()
var selecteds: Array = Array()
var current: GraphNode
var all: Dictionary = Dictionary()

onready var tab:TabContainer = get_node("work/main")
onready var debuger:RichTextLabel = get_node("work/side/debug")
onready var side:HBoxContainer = get_node("work/side")
onready var editor:GraphEdit = get_node("work/main/GraphEdit")
onready var run_btn:Button = get_node("run")
onready var save_btn:Button = get_node("save")
onready var load_btn:Button = get_node("load")
onready var ctxmenu:Node = get_node("work/side/menu")
onready var basic:Node = r_basic.instance()

var debug_mes = "\n \t {mes}"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# 上下文菜单
	ctxmenu.connect("node_created", self, "on_popmenu_node_created")
	

	# 运行
	run_btn.connect("button_down", self, "run")
	save_btn.connect("button_down", self, "save")
	load_btn.connect("button_down", self, "load") 

	# 节点编辑器
	editor.connect("node_selected", self, "on_node_selected")
	editor.connect("node_unselected", self, "on_node_unselected")
	editor.connect("copy_nodes_request", self, "on_copy_nodes_request")
	editor.connect("paste_nodes_request", self, "on_paste_nodes_request")
	editor.connect("connection_request", self, "on_connection_request")
	editor.connect("disconnection_request", self, "on_disconnection_request")
	editor.connect("delete_nodes_request", self, "on_delete_nodes_request")

	# 环境初始化完成
	PGL.connect("env_ready", self, "on_env_ready")
	PGL._readyEnv(env_0, env_ex)
	
	pass # Replace with function body.

# region 上下文初始化完成
func on_env_ready():
	ctxmenu.contextDic = PGL.contextDic
	ctxmenu._refresh("")
# endregion

# region 从上下文菜单创建节点
func on_popmenu_node_created(ctx:Dictionary, item:TreeItem):
	print_debug(ctx)
	var name:String = item.get_text(0)
	var flow_ctx:Dictionary = Dictionary()
	var __id = Time.get_ticks_msec()
	var vp:Viewport = get_viewport()
	var point:Vector2 = editor.scroll_offset
	point.x += 200
	point.y += 200
	var node:GraphNode = _create_node_common(ctx, __id, flow_ctx, name, point)
	editor.add_child(node)
	pass

func _create_ports(name:String)->Node:
	var port:Control = basic.get_node("ports/"+name)
	return port.duplicate()

func _create_node_common(ctx, id, node_ctx, title, point)->GraphNode:
	var node:GraphNode = _create_ports("graph")
	for key in ctx:
		var item1 = ctx[key]
		print_debug(item1)
		# 左/右端
		var sid:int = item1.slot
		# 插槽UI
		var path = item1.type 
		var slot:Control = _create_ports(path)
		if(item1.has("u_source")):
			var u_source = item1.u_source
			process_u_source(slot, u_source, sid)
		# 上下文传递, 插槽的上下文
		var ctx_item = item1.duplicate()
		ctx_item.__key = key
		node_ctx[key] = ctx_item
		slot.set_meta("ctx", ctx_item)
		node.add_child(slot)
		var i = slot.get_index()
		node.set_slot(i, (sid == 0 || sid == 2), 0, 0xffffff, (sid == 1 || sid == 2 ), 0, 0xff00ff)
		pass
	# 节点的上下文
	node.set_meta("__id", id)
	node.set_meta("ctx", node_ctx)
	node.set_offset(point)
	node.theme = key_theme
	node.title = title
	node.name = title
	all[id] = node
	# node.owner = editor
	return node

# func create_node_by_saved(data:Dictionary, title:String)->GraphNode:
# 	var point = Vector2(data.offset[0], data.offset[1])
# 	var node = _create_node_common(data.ctx, data.__id, { }, title, point)
# 	editor.add_child(node)
# 	return node
# 	pass

func process_u_source(slot:Control, u_source, sid:int):
	if(slot is Label):
		slot.text = u_source
		# 右端
		if(sid == 1):
			slot.align = 2 
	elif(slot is OptionButton):
		for name in u_source:
			slot.add_item(name)
			pass
# endregion

# region graphedit操作
func on_node_selected(node:Node):
	current = node
	if(selects.has(node)):
		return
	selects.append(node)
	pass 

func on_node_unselected(node:Node):
	selects.erase(node)
	pass

func on_copy_nodes_request():
	selecteds = selects.duplicate(false)
	print(selecteds)

func on_paste_nodes_request():
	var vp:Viewport = get_viewport()
	var point:Vector2 = vp.get_mouse_position()
	var offset:Array = [0, 0]
	var ox:int = 100
	var oy:int = 50
	for item in selecteds:
		item = item as GraphNode
		var newNode:GraphNode = item.duplicate(8)
		var v: Vector2 = Vector2(offset[0] + point.x, offset[1] + point.y)
		newNode.set_offset(v)
		newNode.remove_meta('id')
		editor.add_child(newNode)
		offset[0] += ox
		offset[1] += oy
		pass
	pass

func on_delete_nodes_request():
	pass

# endregion

# region graphedit 连接/断开连接/流
static func _finder(item, options)->bool:
	var ctx = item.get_meta("ctx")
	if(ctx.slot == 2 || ctx.slot == options.slot):
		return true
	return false

func _array_filter(array:Array, filter:FuncRef, options:Dictionary) -> Array:
	var result = []
	for item in array:
		if(filter.call_func(item, options)):
			result.append(item)
		pass
	return result

func find_ctx_slot(name:String, slot:int, slot_id:int):
	var parent:GraphNode = editor.get_node(name)
	var children:Array = parent.get_children()
	var temp = funcref(self, "_finder")
	var _children:Array = _array_filter(children, temp, {"slot":slot, "slot_id":slot_id})
	if(_children.size() > slot_id):
		return _children[slot_id]

func on_connection_request(from:String, from_slot:int, to:String, to_slot:int):
	
	var result:int = editor.connect_node(from, from_slot, to, to_slot)
	var slot:Control = find_ctx_slot(to, 0, to_slot)
	var ctx:Dictionary = slot.get_meta("ctx")
	var slot_from:Control = find_ctx_slot(from, 1, from_slot) 
	var ctx_from:Dictionary = slot_from.get_meta("ctx")
	var id = slot_from.get_parent().get_meta("__id") 
	if(!ctx.has("A")):
		ctx.A = { }
	if(!ctx.A.has(id)):
		ctx.A[id] = { }
	ctx.A[id][ctx_from.__key] = true

	pass 

func on_disconnection_request(from:String, from_slot:int, to:String, to_slot:int):
	editor.disconnect_node(from, from_slot, to, to_slot)
	var slot:Control = find_ctx_slot(to, 0, to_slot)
	var ctx:Dictionary = slot.get_meta("ctx")
	var slot_from:Control = find_ctx_slot(from, 1, from_slot) 
	var id = slot_from.get_parent().get_meta("__id") 
	var ctx_from:Dictionary = slot_from.get_meta("ctx")

	if(!ctx.has("A")):
		return
	if(!ctx.A.has(id)):
		return
	ctx.A[id].erase(ctx_from.__key)
	
	pass # Replace with function body.

# endregion

# region 保存/加载
func save():
	_save()
	pass

func _save():
	var children = editor.get_children()
	var targets = { }
	for node in children:
		if(!(node is GraphNode)):
			continue
		var id = node.get_meta("__id")
		var title = node.title
		var offset = node.get_offset()
		offset = [offset.x, offset.y]
		var ctx = node.get_meta("ctx")
		targets[id] = { "title":title, "offset":offset, "ctx":ctx, "__id":id }
		pass
	var uid = Time.get_datetime_string_from_system()
	var saved = { uid:targets }
	var result = PGL.yaml.print(saved)
	print_debug(result)
	pass

func load():
	pass

func _load(ctx:Dictionary):

	pass

# 具体生成由env/第三方后端处理
func run():

	# env.run()
	pass

func findOutput():
	var children = editor.get_children()
	var output
	for node in children:
		if(!(node is GraphNode)):
			continue
		if(node.title == "output"):
			output = node
			break
		pass
	if(!output):
		return

func beforeRun(node):
	var ctx = node.get_meta("ctx")
	if(!ctx):
		return
	
	for key in ctx:
		var data = ctx[key]
		if(!data.has("A")):
			continue
			
			break
		pass

func getCtx(node):
	pass
# endregion


# 自定义增加节点行为
func custom_array_add():
	pass
