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
	
func _process(_delta):
	if Input.is_action_pressed("ui_MoveAction"):
		if not selectedUnits.empty():
			$MoveAction.MoveNodesToPosition(get_viewport().get_mouse_position(), selectedUnits)
	#var distance = moveSpeed * _delta;
	#moveAlongPath(distance)

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
				#$Target.position = target
				#$Target.visible = true
			$Targets.showTargets(selectedUnits)
			unitAction = UnitActions.NONE
		elif unitAction == UnitActions.NONE:
			# Clear all the units that were selected
			for unit in selectedUnits:
				unit.setSelected(false)
			$UnitMenu.visible = false
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
	
func OnTargetReached(_target):
	$NuclearExplosion.position = _target
	$NuclearExplosion.visible = true
	$NuclearExplosion.play()
