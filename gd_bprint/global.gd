extends Node

var copyed: Array = Array()
var selects: Array = Array()
var config: Dictionary = Dictionary()
var selecteds: Array = Array()
var current: GraphNode
var current_edit: GraphEdit
var debugs: Array
var inputMaps:Dictionary =  Dictionary()

signal debug(mes)
signal code(code)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if(!(event is InputEventKey)):
		return
	var code:int = event.scancode
	if(!event.is_pressed()):
		inputMaps.erase(code)
		return
	if(!inputMaps.has(code)):
		inputMaps[code] = 1
	else:
		inputMaps[code] += 1
	prints(inputMaps)	

func trigger(code) -> bool:
	if(!inputMaps.has(code)):
		return false
	var triger:bool = (inputMaps[code] == 1)
	return triger
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
