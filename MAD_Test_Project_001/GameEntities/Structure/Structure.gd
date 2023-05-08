extends Node2D

# https://kidscancode.org/godot_recipes/basics/custom_resources/
export (Resource) var StructureInformation
export (Texture) var ConstructionImage
export (Texture) var StructureImage

# Private
enum StructureStateEnum {STRUCTURE_CONSTRUCTING, STRUCTURE_CONSTRUCTION_PAUSED, STRUCTURE_ACTIVE}
var _structureState = StructureStateEnum.STRUCTURE_CONSTRUCTING setget SetStructureState, GetStructureState
var _elapsedContructionTime : float = 0

func _ready():
	if _structureState == StructureStateEnum.STRUCTURE_CONSTRUCTING:	
		$EntityObfuscation.SetNoneTexture(ConstructionImage)
		
		setShowInfoUI(false)
	$Selection.setCallback(funcref(self, "setShowInfoUI"))

func _process(delta):
	if _structureState == StructureStateEnum.STRUCTURE_CONSTRUCTING:
		_elapsedContructionTime += delta
		if _elapsedContructionTime >= StructureInformation.ContructionTimeDays:
			_structureState = StructureStateEnum.STRUCTURE_ACTIVE
			$EntityObfuscation.SetNoneTexture(StructureImage)
			
	_processInfoUI()

func _processInfoUI() -> void:
	$"%BuildPercentage".text = str("%.0f" % (_elapsedContructionTime/StructureInformation.ContructionTimeDays * 100) + "%")
	
	if _structureState == StructureStateEnum.STRUCTURE_ACTIVE:
		$"%BuildPercentage".visible = false
		$"%PauseConstruction".visible = false
		
func SetStructureState(var state):
	_structureState = state
	
func GetStructureState():
	return _structureState
	
func isStructureConstructing() -> bool:
	return _structureState == StructureStateEnum.STRUCTURE_CONSTRUCTING
	
func getBaseConstructionCost() -> int:
	return StructureInformation.ContructionCost
	
func setShowInfoUI(show: bool) -> void:
	if _structureState == StructureStateEnum.STRUCTURE_CONSTRUCTING:
		$"%BuildPercentage".visible = show
		$"%PauseConstruction".visible = show
		
func onPauseConstructionPressed():
	if _structureState == StructureStateEnum.STRUCTURE_CONSTRUCTION_PAUSED:
		_structureState = StructureStateEnum.STRUCTURE_CONSTRUCTING
	else:
		_structureState = StructureStateEnum.STRUCTURE_CONSTRUCTION_PAUSED
