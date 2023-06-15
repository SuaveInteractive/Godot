extends Control

signal WindowClosed()

var DetectionProcessor = null
var SelectedDetectionNode = null

func _ready():
	$"%TimerValue".text = "---"
	
func _process(delta):
	if is_instance_valid(SelectedDetectionNode):
		$"%TimerValue".text = str("%.1f" % SelectedDetectionNode.detectionTimer)
		
		var detectionStr : String = str("[%s]" % _detectorsToString(SelectedDetectionNode.detectors))
		$"%LevelsValue".text = str(detectionStr)
		
		#$"%DetectionValue".text = str(SelectedDetectionNode.detectedAtLevel)
		
func setDetectionProcessor(var detectionProcessor):
	DetectionProcessor = detectionProcessor
	Refresh()
	
func Refresh():
	$"%Detections".clear()
	for key in DetectionProcessor.DetectionDic:
		$"%Detections".add_item(key.get_path())
		$"%Detections".set_item_metadata ($"%Detections".get_item_count() - 1, DetectionProcessor.DetectionDic[key])
		
		if $"%Detections".get_selected_items().size() < 1:
			$"%Detections".select(0)
			SelectedDetectionNode = $"%Detections".get_item_metadata(0)

func _detectorsToString(detectors) -> String:
	var retStr : String = ""
	for key in detectors:
		var detector = detectors[key]
		retStr = retStr + "["
		for lvl in detector.detectionLevels:
			if lvl == detector.detectedAtLevel:
				retStr = retStr + "*" + str(lvl) + "*"
			else:
				retStr = retStr + str(lvl)
			retStr = retStr + " "
		retStr = retStr + "]"
	return retStr

func _on_Window_WindowClosed():
	emit_signal("WindowClosed")

func _on_Detections_item_selected(index):
	SelectedDetectionNode = $"%Detections".get_item_metadata(index)
	
