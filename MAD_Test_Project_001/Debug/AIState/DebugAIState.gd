extends Control

# https://www.youtube.com/watch?v=L5QjuFe5Gys

signal WindowClosed()

func _ready():
	get_node("AIStateWindow/VBoxContainer/CurrentAction").visible = false
	#$AIStateWindow.get_close_button().hide()
	
	$AIStateWindow/VBoxContainer/OptionButton.add_item("Country 1")
	$AIStateWindow/VBoxContainer/OptionButton.add_item("Country 2")
	$AIStateWindow/VBoxContainer/OptionButton.add_item("Country 3")
	
	$AIStateWindow.connect("WindowClosed", self, "OnWindowClosed")
	
func _on_OptionButton_item_selected(index):
	$AIStateWindow/VBoxContainer/CurrentAction.visible = true
	
func OnWindowClosed():
	hide()
	queue_free()
	
	emit_signal("WindowClosed")
