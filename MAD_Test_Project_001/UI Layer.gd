extends CanvasLayer

func _ready():
	pass


func _on_GameActions_ShowUIOverlay(uiOverlayInstance):
	if uiOverlayInstance == null:
		push_error("Overlay passed to UILayer:ShowUIOverlay is null.")
		return
		
	if typeof(uiOverlayInstance) != TYPE_OBJECT:
		push_error("Invalid type passed to UILayer:ShowUIOverlay. Needs to be a PackedScene.")
		return
	
	add_child(uiOverlayInstance, true)


func _on_GameActions_HideUIOverlay(uiOverlayInstance):
	if uiOverlayInstance == null:
		push_error("Overlay passed to UILayer:HideUIOverlay is null.")
		return
		
	if typeof(uiOverlayInstance) != TYPE_OBJECT:
		push_error("Invalid type passed to UILayer:HideUIOverlay. Needs to be a PackedScene.")
		return
	
	remove_child(uiOverlayInstance)
