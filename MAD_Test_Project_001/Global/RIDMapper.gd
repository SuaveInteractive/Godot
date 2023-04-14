extends Node

var RIDMap : Dictionary = {}
	
func addMapping(var name : String, var resourceID : RID) -> void:
	RIDMap[name] = resourceID
	
func getMapping(var name : String) -> RID:
	if not RIDMap.has(name):
		return RID()
	return RIDMap[name]
