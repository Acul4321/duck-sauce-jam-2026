extends CanvasLayer

class_name WinScreen

func _ready() -> void:
	print("Win screen ready")
	# Make sure we can receive input
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_menu_button_pressed() -> void:
	print("Menu button pressed, returning to title screen")
	get_tree().change_scene_to_file("res://scene/titleScreen/titleScreen.tscn")
