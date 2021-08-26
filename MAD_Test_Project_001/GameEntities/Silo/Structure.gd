extends Area2D

# Public
var ContructionTime : float = 5.0



# Private
enum StructureStateEnum {STRUCTURE_CONSTRUCTING, STRUCTURE_ACTIVE}
var _structureState = StructureStateEnum.STRUCTURE_CONSTRUCTING
var _elapsedContructionTime : float = 0

func _ready():
	Signals.connect("UnitsSelected", self, "OnUnitsSelected")
	$Selection.connect("EntitySelected", self, "OnEntitySelected")
	
	if _structureState == StructureStateEnum.STRUCTURE_CONSTRUCTING:
		$Sprite.visible = false
		$Construction.visible = true

func _process(delta):
	if _structureState == StructureStateEnum.STRUCTURE_CONSTRUCTING:
		_elapsedContructionTime += delta
		if _elapsedContructionTime >= ContructionTime:
			_structureState = StructureStateEnum.STRUCTURE_ACTIVE
			
			$Sprite.visible = true
			$Construction.visible = false
			
func OnEntitySelected(entity):
	Signals.emit_signal("UnitSelected", self)
	
func OnUnitsSelected(units: Array) -> void:
	if units.empty():
		$Selection.setSelected(false)
	else:
		for unit in units:
			if unit == self:
				$Selection.setSelected(true)
