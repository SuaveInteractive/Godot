extends Node

# https://www.youtube.com/watch?v=ML-hiNytIqE

signal OnPostLoad()

func _process(_delta):
	if Input.is_action_just_pressed("QuickSave"):
		save_game()
	elif Input.is_action_just_pressed("QuickLoad"):
		load_game()

# https://docs.godotengine.org/en/3.1/tutorials/io/saving_games.html
# C:\Users\Manix\AppData\Roaming\Godot\app_userdata\MAD_Test_Project_001
func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persistent")
	for i in save_nodes:
		var node_data = i.call("save");
		save_game.store_line(to_json(node_data))
	save_game.close()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persistent")
	for i in save_nodes:
		i.set_name(i.get_name() + "_QUEUED_FREE")
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var parentNode = null
	save_game.open("user://savegame.save", File.READ)
	while not save_game.eof_reached():
		parentNode = null
		
		var current_line = parse_json(save_game.get_line())
		if current_line == null:
			break
		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = null
		#===== Scenes =====
		if current_line.has("filename"):	# Load a Scene into game
			var path = current_line["filename"]
			
			new_object = load(path).instance()
			parentNode = get_node(current_line["parent"])
			if not parentNode.has_method ("addChildMethod"):
				get_node(current_line["parent"]).add_child(new_object)
				
			var nodeName = current_line["name"]
			if new_object == null and not nodeName.empty():
				new_object = get_node(nodeName)
		#===== Scripts =====	
		elif current_line.has("scriptPath"):		# Load a Script into game
			var script = current_line["scriptPath"]
			# https://docs.godotengine.org/en/3.0/classes/class_object.html#class-object-callv
			var args = current_line["args"]
			new_object = load(script).callv("new", current_line["args"])
			get_node(current_line["parent"]).add_child(new_object)
		
		new_object.load(current_line)

		# Now we set the remaining variables.
		for i in current_line.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, current_line[i])
			
		if parentNode != null and parentNode.has_method ("addChildMethod"):
			parentNode.call("addChildMethod", new_object)
	save_game.close()
	
	emit_signal("OnPostLoad")
	
