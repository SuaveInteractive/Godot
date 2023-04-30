extends Node

var SettingsDic : Dictionary = {}
var resourcePath : String = "user://DebugGlobalSettings.dat"

func _ready():
	SettingsDic = _load()

func Set(var name : String, var value) -> void:
	SettingsDic[name] = value
	_save()

func Get(var name : String):
	if SettingsDic.has(name):
		return SettingsDic[name]
	return null
	
func _save() -> void:
	var file = File.new()
	file.open(resourcePath, File.WRITE)
	file.store_line(to_json(SettingsDic))
	file.close()

func _load():
	var file = File.new()
	file.open(resourcePath, File.READ)
	var content = parse_json(file.get_as_text())
	file.close()
	if content == null:
		return {}
	return content
