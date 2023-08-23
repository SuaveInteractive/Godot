extends Node2D

# Shader
# https://godotshaders.com/shader/radar-with-trace-blip/

func _ready():
	var subDetectionNode = $Submarine.get_node("DetectorNode")
	subDetectionNode.connect("EnitityDetected", self, "OnSubDetection")
	
	$Submarine.get_node("MoveNode").path = [Vector2(50, 200), Vector2(50, 250), Vector2(200, 250)]
	
	setRadarState(true)
	
	$DebugDetectionState.setDetectionProcessor($DetectionProcessing)

func setRadarState(var showing) -> void:
	if showing:
		$"%RadarToggle".text = "Hide Radar"
	else:
		$"%RadarToggle".text = "Show Radar"
		
	$"%RadarToggle".pressed = showing
	$Node2D/DetectorNode.setDetectionAreaVisibility(showing)
	$Submarine.get_node("DetectorNode").setDetectionAreaVisibility(showing)

func _on_RadarToggle_toggled(button_pressed):
	setRadarState(button_pressed)

func OnSubDetection(detectorEntity, detectorShapeIndex, entityDetectorNode) -> void:
	pass
	
func _on_DetectorNode_EnitityDetected(detector, detectorShapeIndex, detected):
	$DetectionProcessing.addDetection(detector, detectorShapeIndex, detected)
	
func _on_DetectorNode_EnitityUndetected(detectorEntity, detectorShapeIndex, entityDetectorNode):
	$DetectionProcessing.removeDetection(detectorEntity, detectorShapeIndex, entityDetectorNode)
