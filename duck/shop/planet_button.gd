extends TextureButton

class_name PlanetButton

@export var modulateHovered := Color(1.2, 1.2, 1.2, 1.0)
@export var modulatePressed := Color(0.75, 0.75, 0.75, 1)
@export var modulateDisabled := Color(0.2, 0.2, 0.2, 1)
@export var planet: PlanetClass

var isPressed := false
var isHovered := false

func _ready() -> void:
	if(planet):
		texture_normal = planet.texture


func _process(delta: float) -> void:
	if (disabled && modulate != modulateDisabled):
		modulate = modulateDisabled
	if (!disabled && modulate == modulateDisabled):
		modulate = Color(1,1,1,1)

func _on_mouse_entered() -> void:
	isHovered = true
	if !isPressed: modulate = modulateHovered


func _on_mouse_exited() -> void:
	isHovered = false
	if !isPressed: modulate = Color(1,1,1,1)


func _on_button_down() -> void:
	isPressed = true
	modulate = modulatePressed


func _on_button_up() -> void:
	isPressed = false
	if isHovered:
		modulate = modulateHovered
	else:
		modulate = Color(1,1,1,1)
