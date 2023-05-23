extends Node2D
class_name DetectNode

## The area where this node can detect other detection shapes
export (Array, Shape2D) var DetectorArea = []
## The shape that this object can be detected (think rader cross-section)
export (Array, Shape2D) var DetectionShapes = []

export (int) var DetectorLayerBit = 30
export (int) var DetectionLayerBit = 31

signal EnitityDetected(detector, detectorShapeIndex, detected)
signal EnitityUndetected(detector, detectorShapeIndex, detected)

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
	
	_createDetectionAreaTexture()
	setDetectionAreaVisibility(false)
	
func get_class(): 
	return "DetectNode"
		
func addCollisionShape(shape2D : Shape2D, child : Node) -> void:
	var newCollisionShape = CollisionShape2D.new()
	newCollisionShape.set_shape(shape2D)
	child.add_child(newCollisionShape)
	
func getDetectionAreas() -> Array:
	return $DetectorArea.get_children()
	
func setDetectionAreaVisibility(var visibility) -> void:
	$RadarCoverage.visible = visibility
	
func getRadarVisibility() -> bool:
	return $RadarCoverage.visible
	
func _createDetectionAreaTexture() -> void:
	var arrayRadius = []
	for child in $DetectorArea.get_children():
		if child is CollisionShape2D:
			var shape = child.shape
			if shape is CircleShape2D:
				arrayRadius.append(shape.radius)
	if arrayRadius.size() > 0:
		arrayRadius.sort()
		var largestRange = arrayRadius.back()
		if largestRange != null:
			var textureWidth = largestRange * 2
			var texture = ImageTexture.new()
			var image = Image.new()
			image.create(textureWidth, textureWidth, false, Image.FORMAT_RGBAF)
			texture.create_from_image(image)
			$RadarCoverage.texture = texture
			
			_setDetectionAreaShaderParams(arrayRadius)
			
func _setDetectionAreaShaderParams(var sortedArrayRadius : Array) -> void:
		var largestRange = sortedArrayRadius.back()
		var shaderParamArray = ["visualRange", "shortRangeRadar", "mediumRangeRadar", "longRangeRadar"]
		for param in shaderParamArray:
			$RadarCoverage.get_material().set_shader_param(param, 1.0)	

		for n in sortedArrayRadius.size():
			var val = sortedArrayRadius[n] / largestRange
			$RadarCoverage.get_material().set_shader_param(shaderParamArray[n], val)	
			
func _on_DetectorArea_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area != $DetectionArea:
		emit_signal("EnitityDetected", get_parent(), local_shape_index, area.get_parent())

func _on_DetectorArea_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area != $DetectionArea:
		emit_signal("EnitityUndetected", get_parent(), local_shape_index, area.get_parent())
