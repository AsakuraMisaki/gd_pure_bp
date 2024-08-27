signal copy
signal paste
signal select
signal un_select

extends MyEdit

onready var tab:TabContainer = get_node("work/TabContainer")
onready var debuger:RichTextLabel = get_node("work/HBoxContainer/debug")

export(Resource) var env:Resource
export(PackedScene) var r_popmenu:PackedScene 

onready var popmenu:Node = r_popmenu.instance()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var debug_mes = "\n \t {mes}"

# Called when the node enters the scene tree for the first time.
func _ready():
	# env.instance()
	# prints(env.envs, env.path)
	
	# PGL.connect("debug", self, "write_debug")
	# PGL.emit_signal("debug", "working")
	# PGL.emit_signal("debug", "vesion .1")
	pass # Replace with function body.

func _input(event):
	
	if(PGL.trigger(KEY_CENT)):
		var g:GraphNode = PackedEnv._makeGraphNode(PackedEnv.contextDic.Array.splice)
		var vp:Viewport = get_viewport()
		var point:Vector2 = vp.get_mouse_position()
		g.set_offset(point)
		self.add_child(g)
	if(PGL.trigger(KEY_SPACE)):
		if(self.get_children().has(popmenu)):
			self.remove_child(popmenu)
		else:
			var vp:Viewport = get_viewport()
			var point:Vector2 = vp.get_mouse_position()
			popmenu.set_position(point)
			self.add_child(popmenu)

# Called every frame. 'delta' is the elapsed time since the previous frame.
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

func _on_tab_change(slot:int):
	var now = tab.get_current_tab_control()
	var pre = tab.get_tab_control(tab.get_previous_tab())
	if(not(now is GraphEdit) || not(pre is GraphEdit)): return
	# pre = pre
	# now = now
	if(pre && (pre.selects is Array)):
		pre.selects = PGL.selects
	if(now && (now.selects is Array)):
		PGL.selects = now.selects
	prints(PGL.selects, pre, now)

func write_debug(mes:String):
	debuger.add_text(debug_mes.format({"mes":mes}))
	pass

func run():
	var now:GraphEdit = tab.get_current_tab_control()
	var entry:GraphNode = now.get_node("entry")
	_run(entry)
	pass

func _run(entry:GraphNode):
	pass
