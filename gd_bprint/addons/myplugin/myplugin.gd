tool
extends EditorPlugin

var dock:TextEdit
var current_node:Node

func _enter_tree():
	dock = preload("res://addons/myplugin/meta_creator.tscn").instance()
	dock.connect("text_changed", self, "apply_text_meta")
	add_control_to_dock(DOCK_SLOT_LEFT_UL, dock)
	pass

func _exit_tree():
	remove_control_from_docks(dock)
	# Erase the control from the memory.
	dock.free()
	pass

func apply_text_meta():
	if(!current_node): return
	var text:String = dock.text
	print(text)
	current_node.set_meta("custom_editor_meta", text)


func _process(delta):
	# return
	var inter:EditorInterface = get_editor_interface()
	var select:EditorSelection = inter.get_selection()
	# current_node = get_tree().current_scene
	# prints(dock)
	if(select):
		var nodes:Array = select.get_selected_nodes()
		if(nodes.size() && (current_node != nodes[0])):
			current_node = nodes[0]
			prints(current_node)
			if(current_node.has_meta("custom_editor_meta")):
				var current_meta_text = current_node.get_meta("custom_editor_meta")
				dock.text = current_meta_text
			else:
				dock.text = ""
				
	# if node:
	# 		# 如果当前选中的节点有自定义元数据，显示在面板中
	# 		if node.has_meta("my_key"):
	# 			dock.text = "Meta value for 'my_key': " + node.get_meta("my_key")
	# 		else:
	# 			dock.text = "No meta data for 'my_key'"
