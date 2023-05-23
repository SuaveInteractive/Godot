extends Node2D

# Shader
# https://godotshaders.com/shader/radar-with-trace-blip/

func _ready():
	$Submarine.get_node("MoveNode").path = [Vector2(0, 200)]
	
	setRadarState(true)

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
