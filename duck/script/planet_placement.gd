extends Node2D

var planet_scene = preload("res://scene/planet/planet.tscn")
var win_screen_scene = preload("res://scene/win_screen.tscn")
var preview_sprite: Sprite2D
var last_planet: PlanetClass = null
var won: bool = false
@onready var orbit_ghost: Node2D = get_node("game/orbit_ghost")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Create the preview sprite
	preview_sprite = Sprite2D.new()
	preview_sprite.modulate = Color(1, 1, 1, 0.5)  # 50% transparent
	%game.add_child(preview_sprite)
	
	# Update preview with initial planet
	update_preview()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Check for win condition - if there's a Sun in orbit
	if not won and Planet.orbiting_planets.has("Sun") and Planet.orbiting_planets["Sun"] > 0:
		show_win_screen()
	
	# Update preview position to follow mouse
	if preview_sprite:
		preview_sprite.global_position = get_global_mouse_position()
		preview_sprite.visible = Planet.place_mode
		if orbit_ghost:
			orbit_ghost.visible = Planet.place_mode
		if Planet.can_place:
			preview_sprite.modulate = Color(1, 1, 1, 0.5)
		else:
			preview_sprite.modulate = Color(1, 0, 0, 0.5)
	
	# Check if planet selection changed
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
		update_preview()
	
	# Update preview if planet changed from shop
	var current_planet = Planet.get_planet()
	if current_planet != last_planet:
		update_preview()
		last_planet = current_planet
	
	if Input.is_action_just_pressed("place") and Planet.can_place and Planet.place_mode:
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
	# Exit place mode after placing
	Planet.place_mode = false


func show_win_screen() -> void:
	won = true
	var win_screen = win_screen_scene.instantiate()
	add_child(win_screen)


func button_mouse_entered() -> void:
	pass # Replace with function body.
