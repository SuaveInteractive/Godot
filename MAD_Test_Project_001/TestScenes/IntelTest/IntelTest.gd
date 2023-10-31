extends Node

var timer := 0.0
var testScript : Array = [{"DetectedEntity": $EntityObfuscation, "InfoLevel": 1}]

func _ready():
	pass
	
func _process(delta):
	timer = timer + delta
	if timer > 1.0:
		timer = 0
		if testScript.size() > 0:
			var step = testScript[0]
			testScript.erase(step)
			
			$Intelligence.addIntelFromDetection(null, step.InfoLevel, step.DetectedEntity)

func _on_Intelligence_IntelligenceChanged(changedIntellegence):
	pass # Replace with function body.
