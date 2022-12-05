extends Area2D
			
func save():	
	var saveDict = {
		"filename" : get_filename(),
		"name" : name,
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y
	}
	
	var nodeDict = $MoveNode.save()
	for key in nodeDict:
		saveDict[key] = nodeDict[key]
	return saveDict

func load(_dic):
	position.x = _dic["pos_x"]
	position.y = _dic["pos_y"]
	
	$MoveNode.load(_dic)
