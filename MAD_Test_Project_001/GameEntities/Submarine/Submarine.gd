extends Area2D

var selected : bool = false setget setSelected, getSelected
#var targets : Array = [] setget , getTargets
var PlayerCountry : bool = false

func _ready():
	Signals.connect("UnitsSelected", self, "OnUnitsSelected")
	# Duplicate the shader material so that it's uniforms can be set per object
	$SubmarineSprite.set_material($SubmarineSprite.get_material().duplicate())
		
func setSelected(_selected : bool):
	selected = _selected
	
func getSelected() -> bool:
	return selected
	
func _on_Submarine_input_event(_viewport, event, _shape_idx):
	if not event is InputEventMouseButton:
		return
	if not Input.is_mouse_button_pressed(BUTTON_LEFT):
		return
	
	if event.button_index == BUTTON_LEFT:
		Signals.emit_signal("UnitSelected", self)

func setCountry(country):
	$SubmarineSprite.get_material().set_shader_param("colour", country.CountryColour)
	self.PlayerCountry = country.Player
	
func OnUnitsSelected(units: Array) -> void:
	if units.empty():
		$Selection.setSelected(false)
	else:
		for unit in units:
			if unit == self:
				$Selection.setSelected(true)
		
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
