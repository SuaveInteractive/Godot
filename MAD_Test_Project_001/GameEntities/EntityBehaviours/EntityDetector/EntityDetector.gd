extends Node2D
class_name DetectNode

## The area where this node can detect other detection shapes
export (Array, Shape2D) var DetectorArea = []
## The shape that this object can be detected (think rader cross-section)
export (Array, Shape2D) var DetectionShapes = []

export (int) var DetectorLayerBit = 30
export (int) var DetectionLayerBit = 31

signal EnitityDetected(detector, detected)
signal EnitityUndetected(detector, detected)

# Called when the node enters the scene tree for the first time.
func _ready():
	$DetectorArea.set_collision_layer(0)
	$DetectorArea.set_collision_mask(0)
	$DetectorArea.set_collision_layer_bit(DetectorLayerBit, true)
	$DetectorArea.set_collision_mask_bit (DetectionLayerBit, true)
	
	$DetectionArea.set_collision_layer(0)
	$DetectionArea.set_collision_mask(0)
	$DetectionArea.set_collision_layer_bit (DetectionLayerBit, true)
	$DetectionArea.set_collision_mask_bit (DetectorLayerBit, true)
	
	for shape2D in DetectorArea:
		addCollisionShape(shape2D, $DetectorArea)
		
	for shape2D in DetectionShapes:
		addCollisionShape(shape2D, $DetectionArea)
	
	add_to_group("Detectors")
	
func get_class(): 
	return "DetectNode"
		
func addCollisionShape(shape2D : Shape2D, child : Node) -> void:
	var newCollisionShape = CollisionShape2D.new()
	newCollisionShape.set_shape(shape2D)
	child.add_child(newCollisionShape)
	
func getDetectionAreas() -> Array:
	return $DetectorArea.get_children()

func _on_DetectorArea_area_entered(area):
	if area != $DetectionArea:
		emit_signal("EnitityDetected", get_parent(), area.get_parent())
	
func _on_DetectorArea_area_exited(area):
	if area != $DetectionArea:
		emit_signal("EnitityUndetected", get_parent(), area.get_parent())
