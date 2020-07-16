extends Sprite

var targetOwner : Node = null

func save():
	var save_dict = {
		"filename" : get_filename(),
		"name" : name,
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, 
		"pos_y" : position.y,
		"targetOwnerPath" : targetOwner.get_path()
	}
	return save_dict
	
func load(_dic):
	position.x = _dic["pos_x"]
	position.y = _dic["pos_y"]
	
	# add linking information
	return {obj = self, "targetOwnerPath": _dic["targetOwnerPath"]}

func linkObjects(_dic):
	targetOwner = get_tree().get_root().get_node(_dic["targetOwnerPath"])
