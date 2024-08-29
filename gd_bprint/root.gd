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

export(Resource) var env:Resource
export(PackedScene) var r_popmenu:PackedScene 
export(PackedScene) var r_basic:PackedScene 
export(String) var duplicate_scene_path:String
export(PackedScene) var saver:PackedScene

onready var popmenu:Node = r_popmenu.instance()
onready var basic:Node = r_basic.instance()
var entry:GraphNode
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var debug_mes = "\n \t {mes}"

func _readyBasic():
	var children:Array = basic.get_children()
	var reg = RegEx.new()
	reg.compile("#entry")
	for item in children:
		var pos = item.get_position()
		if(not(item is GraphNode)): continue
		var newNode = item.duplicate(8)
		var has:bool = item.has_meta("custom_editor_meta")
		if(has):
			var des = item.get_meta("custom_editor_meta")
			# the only one entry node
			if(reg.search(des)):
				entry = newNode
				print_debug(entry) 
		newNode.set_offset(Vector2(pos))
		editor.add_child(newNode)

# Called when the node enters the scene tree for the first time.
func _ready():
	popmenu.connect("node_created", self, "on_popmenu_node_created")
	run_btn.connect("button_down", self, "run")
	save_btn.connect("button_down", self, "save")
	_readyBasic()
	pass # Replace with function body.

func on_popmenu_node_created(node:GraphNode):
	var vp:Viewport = get_viewport()
	var point:Vector2 = vp.get_mouse_position()
	node.set_offset(point)
	editor.add_child(node)
	var size:Vector2 = node.get_rect().size
	print_debug(size)
	node.set_size(size * Vector2(1, 1))
	self.remove_child(popmenu)
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
	editor._get_code(node)
	if(node == entry):
		print_debug("entry selected:", node)
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
	var entry:GraphNode = editor.get_node("entry")
	_run(entry)
	pass

func _run(entry:GraphNode):
	pass
