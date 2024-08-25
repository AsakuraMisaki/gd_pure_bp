extends Node

var copyed: Array = Array()
var selects: Array = Array()
var config: Dictionary = Dictionary()
var selecteds: Array = Array()
var current: GraphNode
var current_edit: GraphEdit

signal debug(mes)
signal code(code)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
