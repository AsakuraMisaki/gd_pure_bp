extends Node
signal env_ready
var contextDic: Dictionary = Dictionary()
var basic:Dictionary = Dictionary()
var cfile:File = File.new()
var cfile_ok

var yaml = preload("res://addons/godot-yaml/gdyaml.gdns").new()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _readyEnv(path:String, envs:Array):
	var mainyaml:String = "res://env/{path}/main.yaml".format({"path":path})
	cfile_ok = cfile.open(mainyaml, File.READ)
	# print_debug(envs)
	_prepareCoreCtx()
	# var partern = r"window\[`tdoc-\$\{performance\.now()\}`\]"
	var tar:RegEx = RegEx.new()
	tar.compile("(?i)window\\[`tdoc-\\$\\{performance\\.now\\(\\)\\}`\\]\\s*=\\s*")
	for item in envs:
		var filePath:String = "res://env/{path}/{name}.js".format({"path":path, "name":item})
		print(filePath)
		var file:File = File.new()
		if(!file.file_exists(filePath)):continue
		file.open(filePath, File.READ)
		var content:String = file.get_as_text()
		var result:Array = tar.search_all(content)
		# prints(result)
		if(result):
			for item1 in result:
				var str1:String = item1.get_string()
				content = content.replace(str1, "")
				pass
		# print_debug(content)
		var dic:Dictionary = JSON.parse(content).result
		
		# "Math", "JSON", "Number", "Object", "Date", "RegExp", "ArrayConstructor"
		var targets:Dictionary = _getInterface(dic, 
								["Array", "Number"])
		# merge t.js上下文
		# contextDic.merge(targets)
		file.close()
		pass
	# print_debug(contextDic)
	emit_signal("env_ready")
	pass # Replace with function body.

# ports type get_value
func _get_value(node:Node):
	var custom = node.get_meta("custom_editor_meta")
	# if(custom.match("#flow")):
		

# getInterface from ts
func _getInterface(dic:Dictionary, targets:Array = []) -> Dictionary:
	var groups:Array = dic.groups
	if(!groups): return {}
	
	var infs:Dictionary = Dictionary()
	var tar:RegEx = RegEx.new()
	tar.compile("(?i)Interfaces")
	# for item in groups:
	# 	if(tar.search(item.title)):
	# 		infs = item.children
	# 		break
	var sources:Array = dic.children
	
	for item1 in sources:
		if(targets.has(item1.name) && item1.kind == 256):
			var info:Dictionary = Dictionary()
			print(item1.children.size())
			var children:Array = item1.children
			# PGL.debugs.append(JSON.print(item1.children, "  "))
			for item2 in children:
				PGL.debugs.append(item2.name)
				var temp:Dictionary = Dictionary()
				temp.name = item2.name
				temp.parent = item1.name
				temp.params = []
				temp.kind = item2.kind
				temp.output_info = {}
				if(item2.kind == 2048):
					var p:Array = Array()
					var possible_param = item2.signatures[0].get("parameters", [])
					p = possible_param
					temp.params = p
					for p0 in temp.params:
						var type = p0.get("type", {})
						var name = type.get("name", "")
						var t = type.get("type", "intrinsic")
						p0.type = { "type":t, "name":name }
						pass
				if(item2.kind == 2048):
					var possible_output = item2.signatures[0].get("type", {})
					temp.output_info = possible_output
				elif(item2.kind == 1024):
					var possible_output1 = item2.get("type", {})
					temp.output_info = possible_output1
				temp.output_info.erase("elementType")
				info[temp.name] = temp
				pass	
			infs[item1.name] = info
			
	return infs

func _merge_item(ctx:Dictionary, default_ctx:Dictionary, re):
	for key in ctx:
		if(re.search(key)):
			continue
		var item = ctx[key]
		var find = -1
		for key1 in default_ctx:
			var t_ctx = default_ctx[key1]
			find = key.find(key1) 
			# print_debug(find, item, key1, key)
			if(find==0):
				item.merge(t_ctx)
				print_debug(item)
				break
			pass
		if(find==-1):
			_merge_item(item, default_ctx, re)
		else:
			pass
		# print_debug(item)
		pass

func _prepareCoreCtx():
	var content:String = cfile.get_as_text()
	basic = yaml.parse(content).result
	# print_debug(basic)
	var default_ctx = basic.__default
	var re:RegEx = RegEx.new()
	re.compile("^__")
	_merge_item(basic, default_ctx, re)
	# _merge_item(basic.main__ENTRY, default_ctx)
	# merge_basic(re, basic, default_ctx)
	contextDic.merge(basic)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	
