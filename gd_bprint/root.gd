signal copy
signal paste
signal select
signal un_select

extends MyEdit

onready var tab:TabContainer = get_node("TabContainer")
onready var debuger:TextEdit = get_node("debug")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var debug_mes = "\n \t {mes}"

# Called when the node enters the scene tree for the first time.
func _ready():
	PGL.connect("debug", self, "write_debug")
	PGL.emit_signal("debug", "working")
	PGL.emit_signal("debug", "vesion .1")
	var width:int = 
	PGL.emit_signal("debug", "vesion .1")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	var pre:GraphEdit = tab.get_tab_control(tab.get_previous_tab())
	var now:GraphEdit = tab.get_current_tab_control()
	if(pre && (pre.selects is Array)):
		pre.selects = PGL.selects
	if(now && (now.selects is Array)):
		PGL.selects = now.selects
	prints(PGL.selects, pre, now)

func write_debug(mes:String):
	var text:String = debuger.get_text()
	debuger.set_text(text + debug_mes.format({"mes":mes}))

func run():
	var now:GraphEdit = tab.get_current_tab_control()
	var entry:GraphNode = now.get_node("entry")
	_run(entry)
	pass

func _run(entry:GraphNode):
	pass
