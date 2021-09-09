extends Area2D

# https://kidscancode.org/godot_recipes/basics/custom_resources/
export (Resource) var StructureInformation

# Private
enum StructureStateEnum {STRUCTURE_CONSTRUCTING, STRUCTURE_CONSTRUCTION_PAUSED, STRUCTURE_ACTIVE}
var _structureState = StructureStateEnum.STRUCTURE_CONSTRUCTING setget SetStructureState, GetStructureState
var _elapsedContructionTime : float = 0

func _ready():
	Signals.connect("UnitsSelected", self, "OnUnitsSelected")
	$Selection.connect("EntitySelected", self, "OnEntitySelected")
	
	if _structureState == StructureStateEnum.STRUCTURE_CONSTRUCTING:
		$Sprite.visible = false
		$Construction.visible = true
		setShowInfoUI(false)

func _process(delta):
	if _structureState == StructureStateEnum.STRUCTURE_CONSTRUCTING:
		_elapsedContructionTime += delta
		if _elapsedContructionTime >= StructureInformation.ContructionTimeDays:
			_structureState = StructureStateEnum.STRUCTURE_ACTIVE
			
			$Sprite.visible = true
			$Construction.visible = false
			
	_processInfoUI()

func _processInfoUI() -> void:
	$StructureInformationUI/BuildPercentage.text = str("%.0f" % (_elapsedContructionTime/StructureInformation.ContructionTimeDays * 100) + "%")
	
	if _structureState == StructureStateEnum.STRUCTURE_ACTIVE:
		$StructureInformationUI/BuildPercentage.visible = false
		$StructureInformationUI/PauseConstruction.visible = false
		
func OnEntitySelected(entity):
	Signals.emit_signal("UnitSelected", self)
	
func SetStructureState(var state):
	_structureState = state
	
func GetStructureState():
	return _structureState
	
func isStructureConstructing() -> bool:
	return _structureState == StructureStateEnum.STRUCTURE_CONSTRUCTING
	
func setShowInfoUI(show: bool) -> void:
	if _structureState == StructureStateEnum.STRUCTURE_CONSTRUCTING:
		$StructureInformationUI/BuildPercentage.visible = show
		$StructureInformationUI/PauseConstruction.visible = show
	
func OnUnitsSelected(units: Array) -> void:
	if units.empty():
		$Selection.setSelected(false)
		setShowInfoUI(false)
	else:
		for unit in units:
			if unit == self:
				$Selection.setSelected(true)
				setShowInfoUI(true)
				
func onPauseConstructionPressed():
	if _structureState == StructureStateEnum.STRUCTURE_CONSTRUCTION_PAUSED:
		_structureState = StructureStateEnum.STRUCTURE_CONSTRUCTING
	else:
		_structureState = StructureStateEnum.STRUCTURE_CONSTRUCTION_PAUSED
