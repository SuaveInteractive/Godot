extends AnimatedSprite

func save():
	var save_dict = {
		"filename" : get_filename(),
		"name" : name,
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
	}
	return save_dict

func load(_dic):
	position.x = _dic["pos_x"]
	position.y = _dic["pos_y"]
