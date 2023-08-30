extends Button

signal UICreateIntelligenceButtonToggle(button_pressed)

func _ready():
	pass

func _on_CreateIntelligencePackageBtn_toggled(button_pressed):
	emit_signal("UICreateIntelligenceButtonToggle", button_pressed)
