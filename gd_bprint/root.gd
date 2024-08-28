signal copy
signal paste
signal select
signal un_select

extends MyEdit

onready var tab:TabContainer = get_node("work/TabContainer")
onready var debuger:RichTextLabel = get_node("work/HBoxContainer/debug")
onready var editor:GraphEdit = get_node("work/TabContainer/GraphEdit")

export(Resource) var env:Resource
export(PackedScene) var r_popmenu:PackedScene 

onready var popmenu:Node = r_popmenu.instance()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var debug_mes = "\n \t {mes}"

# Called when the node enters the scene tree for the first time.
func _ready():
	popmenu.connect("node_created", self, "on_popmenu_node_created")
	# env.instance()
	# prints(env.envs, env.path)
	
	# PGL.connect("debug", self, "write_debug")
	# PGL.emit_signal("debug", "working")
	# PGL.emit_signal("debug", "vesion .1")
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

func run():
	var entry:GraphNode = editor.get_node("entry")
	_run(entry)
	pass

func _run(entry:GraphNode):
	pass
