extends TextureButton

var _is_pressed := false
var _is_hovered := false

func _on_mouse_entered() -> void:
	_is_hovered = true
	if !_is_pressed: modulate = Color(1.2, 1.2, 1.2, 1.0)


func _on_mouse_exited() -> void:
	_is_hovered = false
	if !_is_pressed: modulate = Color(1,1,1,1)


func _on_button_down() -> void:
	_is_pressed = true
	modulate = Color(0.75, 0.75, 0.75, 1)


func _on_button_up() -> void:
	_is_pressed = false
	if _is_hovered:
		modulate = Color(1.2, 1.2, 1.2, 1.0)
	else:
		modulate = Color(1,1,1,1)
