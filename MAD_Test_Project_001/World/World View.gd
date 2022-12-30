extends Node

var cityScene = load("res://GameEntities/City/City.tscn")
var siloScene = load("res://GameEntities/Silo/Silo.tscn")
var submarineScene = load("res://GameEntities/Submarine/Submarine.tscn")
var targetScene = load("res://GameEntities/Target/Target.tscn")
var missileScene = load("res://GameEntities/Missile/Missile.tscn")

signal UnitSelected(unit)

func _ready():
	pass
	
func _init():
	pass
	
func _on_World_Model_WorldMapTextureUpdates(texture):
	$WorldMap.texture = texture
			

func _on_World_Model_SelectedEntitiesChanged(selectedEntities):
	for entity in selectedEntities:
		entity.setSelected(true)
	
func _on_World_Model_UnselectedEntitiesChanged(unselectedEntities):
	for entity in unselectedEntities:
		entity.setSelected(false)

func addTarget(selectedUnit, position):
	var targetInstance = targetScene.instance()
	targetInstance.position = position
	targetInstance.set_name("target")
	
	var targetNode = selectedUnit.get_node("TargetNode")
	if targetNode != null:
		targetNode.add_child(targetInstance)
	else:
		selectedUnit.add_child(targetInstance)

func addMissile(source, target) -> void:
	var missileInstance = missileScene.instance()
	missileInstance.set_name("missile")
	missileInstance.setTarget(target)
	missileInstance.position = source
	$Missiles.add_child(missileInstance)
