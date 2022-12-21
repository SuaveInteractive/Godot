# 
# Informaiton about having editor change dynamically
# https://docs.godotengine.org/en/stable/tutorials/misc/running_code_in_the_editor.html#doc-running-code-in-the-editor
#
# Documentation about issue with Area2D overlapping
# https://www.reddit.com/r/godot/comments/xkxuuq/detecting_click_only_on_the_top_area2d/
# https://github.com/godotengine/godot/issues/29825
#
# Possible Future extention
# https://www.youtube.com/watch?v=K9DenBHIDzU
#
tool
extends Node

export(ImageTexture) var SelectionSprite setget setSelectionSprite
export(Vector2) var SelectionArea = Vector2(1, 1) setget setSelectionArea

signal EntitySelected(entity)
signal EntityDeselected(entity)

var SelectionImageSize : Vector2 = Vector2(100, 100)
var DefaultSelectionSize : Vector2 = Vector2(1, 1) * 2
var Scale : Vector2 = DefaultSelectionSize / SelectionImageSize
var mouse_entered : bool = false

func _ready():	
	set_process_unhandled_input(true)
	if not Engine.editor_hint:
		$SelectedSprite.visible = false
					
func setSelected(selected: bool) -> void:
	$SelectedSprite.visible = selected
	
	if selected == false:
		emit_signal("EntityDeselected", self)
	
func _unhandled_input(event : InputEvent) -> void:	
	if not event is InputEventMouseButton:
		return
	if not Input.is_mouse_button_pressed(BUTTON_LEFT):
		return
		
	if event.button_index == BUTTON_LEFT && mouse_entered:
		self.get_tree().set_input_as_handled()
		emit_signal("EntitySelected", self)
	
func setSelectionSprite(texture):	
	SelectionSprite = texture
	if not is_inside_tree():
		yield(self, 'ready');
		
	$SelectedSprite.texture = SelectionSprite
			
func setSelectionArea(selectionArea: Vector2):	
	SelectionArea = selectionArea
	
	#fix the scale of the selection sprite
	Scale = (SelectionArea / SelectionImageSize) * 2
	$SelectedSprite.set_scale(Scale)
		
	$SelectionArea.shape.set_extents(SelectionArea)
	
func _on_Selection_mouse_entered():
	mouse_entered = true

func _on_Selection_mouse_exited():
	mouse_entered = false
