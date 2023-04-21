extends Viewport

func _ready():
	pass
	
func setDetectionAreas(var detectorNodes : Array) -> void:
	$DetectorRender.setDetectionNodes(detectorNodes)
