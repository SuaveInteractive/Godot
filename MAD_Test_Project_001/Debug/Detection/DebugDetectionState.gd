extends Control

signal WindowClosed()

var DetectionProcessor = null
var SelectedDetectionNode = null

func _ready():
	$"%TimerValue".text = "---"
	
func _process(delta):
	if is_instance_valid(SelectedDetectionNode):
		$"%TimerValue".text = str("%.1f" % SelectedDetectionNode.detectionTimer)
		$"%LevelsValue".text = str(SelectedDetectionNode.detectionLevels)
		$"%DetectionValue".text = str(SelectedDetectionNode.detectedAtLevel)
		
func setDetectionProcessor(var detectionProcessor):
	DetectionProcessor = detectionProcessor
	Refresh()
	
func Refresh():
	$"%Detections".clear()
	for key in DetectionProcessor.DetectionDic:
		$"%Detections".add_item(key.get_path())
		$"%Detections".set_item_metadata ($"%Detections".get_item_count() - 1, DetectionProcessor.DetectionDic[key])

func _on_Window_WindowClosed():
	emit_signal("WindowClosed")

func _on_Detections_item_selected(index):
	SelectedDetectionNode = $"%Detections".get_item_metadata(index)
	
