extends Node2D

var planet_scene = preload("res://scene/planet/planet.tscn")
var preview_sprite: Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Create the preview sprite
	preview_sprite = Sprite2D.new()
	preview_sprite.modulate = Color(1, 1, 1, 0.5)  # 50% transparent
	%game.add_child(preview_sprite)
	
	# Update preview with initial planet
	update_preview()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Update preview position to follow mouse
	if preview_sprite:
		preview_sprite.global_position = get_global_mouse_position()
		if Planet.can_place:
			preview_sprite.modulate = Color(1, 1, 1, 0.5)
		else:
			preview_sprite.modulate = Color(1, 0, 0, 0.5)
	
	# Check if planet selection changed
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
		update_preview()
	
	if Input.is_action_just_pressed("place") and Planet.can_place:
		spawn_planet_at_mouse()


func update_preview() -> void:
	if not preview_sprite:
		return
	
	var current_planet = Planet.get_planet()
	preview_sprite.texture = current_planet.texture
	preview_sprite.scale = Vector2(current_planet.scale, current_planet.scale)


func spawn_planet_at_mouse() -> void:
	var mouse_pos = get_global_mouse_position()
	var current_planet = Planet.get_planet()
	var new_planet = Planet._create_planet_node(current_planet, mouse_pos)
	%game.add_child(new_planet)
