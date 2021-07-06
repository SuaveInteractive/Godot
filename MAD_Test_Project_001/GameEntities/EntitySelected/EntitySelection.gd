# 
# Informaiton about having editor change dynamically
# https://docs.godotengine.org/en/stable/tutorials/misc/running_code_in_the_editor.html#doc-running-code-in-the-editor
#
tool
extends Node

export(ImageTexture) var SelectionSprite setget setSelectionSprite
export(Vector2) var SelectionArea = Vector2(1, 1) setget setSelectionArea

var SelectionImageSize : Vector2 = Vector2(100, 100)
var DefaultSelectionSize : Vector2 = Vector2(1, 1) * 2
var Scale : Vector2 = DefaultSelectionSize / SelectionImageSize


#var Selected : bool = false
#var PlayerCountry : bool = false

func _ready():	
	if not Engine.editor_hint:
		$SelectedSprite.visible = false
			
func setSelected(selected: bool) -> void:
	$SelectedSprite.visible = selected

func _on_Selection_input_event(viewport, event, shape_idx):
	if not event is InputEventMouseButton:
		return
	if not Input.is_mouse_button_pressed(BUTTON_LEFT):
		return
	
	if event.button_index == BUTTON_LEFT:
		 Signals.emit_signal("EntitySelected", self)
		
func setSelectionSprite(texture):	
	SelectionSprite = texture
	if not is_inside_tree():
		yield(self, 'ready');
		
	$SelectedSprite.texture = SelectionSprite
			
func setSelectionArea(selectionArea: Vector2):	
	SelectionArea = selectionArea
	
	#fix the scale of the selection sprite
	var Scale = (SelectionArea / SelectionImageSize) * 2
	$SelectedSprite.set_scale(Scale)
		
	$SelectionArea.shape.set_extents(SelectionArea)
	
	
