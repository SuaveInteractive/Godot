extends Node2D
class_name DetectNode

## The area where this node can detect other detection shapes
export (Array, Shape2D) var DetectorArea = []
## The shape that this object can be detected (think rader cross-section)
export (Array, Shape2D) var DetectionShapes = []

export (int) var DetectorLayer = 31
export (int) var DetectionLayer = 32

signal EnitityDetected(Entity)
signal EnitityUndetected(Entity)

# Called when the node enters the scene tree for the first time.
func _ready():
	$DetectorArea.collision_layer = DetectorLayer
	$DetectorArea.collision_mask = DetectionLayer
	
	$DetectionArea.collision_layer = DetectionLayer
	$DetectionArea.collision_mask = DetectorLayer	
	
	for shape2D in DetectorArea:
		addCollisionShape(shape2D, $DetectorArea)
		
	for shape2D in DetectionShapes:
		addCollisionShape(shape2D, $DetectionArea)
	
	add_to_group("Detectors")
	
#func _draw():
#	draw_circle (position, 20.0, Color(1.0, 0.0, 0.0) )
		
func addCollisionShape(shape2D : Shape2D, child : Node) -> void:
	var newCollisionShape = CollisionShape2D.new()
	newCollisionShape.set_shape(shape2D)
	child.add_child(newCollisionShape)

func _on_DetectorArea_area_entered(area):
	if area != $DetectionArea:
		emit_signal("EnitityDetected", area.get_parent())
	
func _on_DetectorArea_area_exited(area):
	if area != $DetectionArea:
		emit_signal("EnitityUndetected", area.get_parent())
