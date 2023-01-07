extends Node

var missileScene = load("res://GameEntities/Missile/Missile.tscn")

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
		
func addMissile(source, target) -> void:
	var missileInstance = missileScene.instance()
	missileInstance.set_name("missile")
	missileInstance.setTarget(target)
	missileInstance.position = source
	$Missiles.add_child(missileInstance)
