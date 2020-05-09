extends Node2D

# https://www.youtube.com/watch?v=Ad6Us73smNs

onready var nav_2d : Navigation2D = $"World Map/Navigation2D"
onready var line_2d : Line2D = $Line2D
onready var submarine : Sprite = $Submarine

class_name Submarine

var path = []
var moveSpeed : float = 20.0

var selectedUnits = []
var target : Vector2 = Vector2(-1, -1)

enum UnitActions {NONE, MoveAction, PatrolAction, TargetAction}
var unitAction = UnitActions.NONE

func _ready():
	$NuclearExplosion.visible = false
	$CreateGame.createGame(self)
	
func _process(_delta):
	if Input.is_action_pressed("ui_MoveAction"):
		if not selectedUnits.empty():
			$MoveAction.MoveNodesToPosition(get_viewport().get_mouse_position(), selectedUnits)
	elif Input.is_action_just_pressed("QuickSave"):
		save_game()
	elif Input.is_action_just_pressed("QuickLoad"):
		load_game()

func moveAlongPath(_distance):
	var lastPos = $Submarine.position
	for i in range(path.size()):
		var distanceToNext = lastPos.distance_to(path[0])
		if _distance <= distanceToNext:
			$Submarine.position = lastPos.linear_interpolate(path[0], _distance / distanceToNext)
			break
		elif _distance < 0.0:
			$Submarine.position = path[0]
			set_process(false)
			break
			
		_distance -= distanceToNext
		lastPos = path[0]
		path.remove(0)

func _unhandled_input(event : InputEvent) -> void:	
	if not event is InputEventMouseButton:
		return
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if unitAction == UnitActions.TargetAction:
			for unit in selectedUnits:
				var mouseEvent = event as InputEventMouse
				target = mouseEvent.position
				$Targets.addTarget(unit, target)
			$Targets.showTargets(selectedUnits)
			unitAction = UnitActions.NONE
		elif unitAction == UnitActions.NONE:
			# Clear all the units that were selected
			for unit in selectedUnits:
				unit.setSelected(false)
			$UnitMenu.visible = false
			$Targets.hideTargets()
			selectedUnits = []

func _on_Button_button_down():
	$LaunchStrike.launchStringOnTargets($Targets.getTargets())

func OnUnitSelected(node):
	node.setSelected(true)
	$UnitMenu.visible = true
	selectedUnits.append(node);
	$Targets.showTargets(selectedUnits)
	
func TargetPressed():
	unitAction = UnitActions.TargetAction
	
func OnTargetReached(_target, _hits):
	$NuclearExplosion.position = _target
	$NuclearExplosion.visible = true
	$NuclearExplosion.play()
	
	#Check any hits
	for hit in _hits:
		if hit == $City:
			$City.setPopulation(49)

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
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://savegame.save", File.READ)
	while not save_game.eof_reached():
		var current_line = parse_json(save_game.get_line())
		if current_line == null:
			break
		# Firstly, we need to create the object and add it to the tree and set its position.
		var path = current_line["filename"]
		var nodeName = current_line["name"]
		var new_object = null
		if not path.empty():
			new_object = load(current_line["filename"]).instance()
			get_node(current_line["parent"]).add_child(new_object)
		elif not nodeName.empty():
			new_object = get_node(nodeName)
			
		new_object.load(current_line)
		# Now we set the remaining variables.
		for i in current_line.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, current_line[i])
	save_game.close()
