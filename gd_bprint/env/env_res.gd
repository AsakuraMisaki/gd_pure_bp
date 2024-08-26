extends Node

export(Array, String) var envs:Array
export(String) var path:String

var contextDic: Dictionary = Dictionary()

# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug(envs)
	for item in envs:
		var filePath:String = "res://env/{path}/{name}.json".format({"path":path, "name":item})
		print(filePath)
		var file:File = File.new()
		if(!file.file_exists(filePath)):continue
		file.open(filePath, File.READ)
		var content:String = file.get_as_text()
		# print_debug(content)
		var dic:Dictionary = JSON.parse(content).result
		contextDic.merge(dic)
		file.close()
		pass
	print_debug(contextDic)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
