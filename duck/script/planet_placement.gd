extends Node2D

var planet_scene = preload("res://scene/planet/planet.tscn")
var win_screen_scene = preload("res://scene/win_screen.tscn")
var preview_sprite: Sprite2D
var last_planet: PlanetClass = null
var won: bool = false
@onready var orbit_ghost: Node2D = get_node("game/orbit_ghost")
@onready var blackhole: Sprite2D = get_node("Blackhole")
@onready var game_node: Node2D = get_node("%game")
@onready var placeFX: AudioStreamPlayer2D = $AudioStreamPlayer2D

var bin_button: Button

# Zoom settings
var min_zoom: float = 0.2
var max_zoom: float = 1.0
var zoom_speed: float = 0.1
var target_zoom: float = 1.0
var current_zoom: float = 0.5

# Blackhole collision offset (additional safe zone around blackhole)
var blackhole_offset: float = 250.0

# Mobile zoom settings
var touch_points: Dictionary = {}
var last_pinch_distance: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#start state
	# Reset to first planet (Pluto) at game start
	if Planet.planets.size() > 0:
		Planet.set_planet(Planet.planets[0])
		Planet.last_shop_planet = Planet.planets[0]  # Reset shop selection too
	# Reset unlocked planets and orbiting counts for new game
	Planet.unlocked_planets.clear()
	Planet.orbiting_planets.clear()
	Planet.place_mode = true
	# Create the preview sprite
	preview_sprite = Sprite2D.new()
	preview_sprite.modulate = Color(1, 1, 1, 0.5)  # 50% transparent
	%game.add_child(preview_sprite)

	# Initialize zoom
	if game_node:
		game_node.scale = Vector2.ONE
	if blackhole:
		blackhole.scale = Vector2(0.013400486, 0.013400486)  # Original scale from scene

	# Find the bin button in the scene tree
	bin_button = get_tree().root.find_child("BinButton", true, false)

	# Update preview with initial planet
	update_preview()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Handle gameplay zoom smoothing
	current_zoom = lerp(current_zoom, target_zoom, zoom_speed)
	if game_node:
		game_node.scale = Vector2(current_zoom, current_zoom)
	if blackhole:
		# Apply zoom to blackhole while preserving its base scale
		var base_scale = 0.013400486
		blackhole.scale = Vector2(base_scale * current_zoom, base_scale * current_zoom)

	# Check for win condition - if there's a Sun in orbit
	if not won and Planet.orbiting_planets.has("Sun") and Planet.orbiting_planets["Sun"] > 0:
		show_win_screen()

	# Update preview position to follow mouse
	if preview_sprite:
		# Convert mouse position to game node's local space (accounting for zoom)
		var mouse_pos = get_global_mouse_position()
		if game_node:
			preview_sprite.position = game_node.to_local(mouse_pos)
		else:
			preview_sprite.global_position = mouse_pos

		preview_sprite.visible = Planet.place_mode
		if orbit_ghost:
			orbit_ghost.visible = Planet.place_mode

		# Check collision with black hole and other planets
		# Start by assuming we can place, then check all collisions
		Planet.can_place = true
		check_blackhole_collision()
		check_planet_collision()
		check_binButton_collision()

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
		spawn_planet_at_mouse(1)

	if Input.is_action_just_pressed("place_anti") and Planet.can_place and Planet.place_mode:
		spawn_planet_at_mouse(-1)


func update_preview() -> void:
	if not preview_sprite:
		return

	var current_planet = Planet.get_planet()
	preview_sprite.texture = current_planet.texture
	preview_sprite.scale = Vector2(current_planet.scale, current_planet.scale)


func spawn_planet_at_mouse(direction: int) -> void:
	var current_planet = Planet.get_planet()
	
	# Check if player has enough money
	if Money.get_money() < current_planet.cost:
		print("Not enough money to place planet!")
		Planet.place_mode = false
		return
	
	# Deduct the cost
	if not Money.spend_money(current_planet.cost):
		print("Failed to spend money")
		Planet.place_mode = false
		return
	
	var mouse_pos = get_global_mouse_position()
	# Convert to game node's local space
	var local_pos = mouse_pos
	if game_node:
		local_pos = game_node.to_local(mouse_pos)

	var new_planet = Planet._create_planet_node(current_planet, local_pos, 0.0, direction)
	%game.add_child(new_planet)
	placeFX.play()
	
	# Check if player still has enough money for another placement
	if Money.get_money() < current_planet.cost:
		print("Not enough money for another planet - exiting place mode")
		Planet.place_mode = false


func show_win_screen() -> void:
	won = true
	var win_screen = win_screen_scene.instantiate()
	add_child(win_screen)


func check_blackhole_collision() -> void:
	if not blackhole or not preview_sprite:
		return

	var mouse_pos = get_global_mouse_position()
	var blackhole_pos = blackhole.global_position

	# Calculate radii (accounting for current zoom)
	var current_planet = Planet.get_planet()
	var planet_radius = (current_planet.texture.get_width() / 2.0) * current_planet.scale * current_zoom
	var blackhole_radius = (blackhole.texture.get_width() / 2.0) * blackhole.scale.x

	# Calculate distance between centers
	var distance = mouse_pos.distance_to(blackhole_pos)

	# Check if radii are overlapping (with additional offset safe zone that scales with zoom)
	if distance < (planet_radius + blackhole_radius + (blackhole_offset * current_zoom)):
		Planet.can_place = false


func check_planet_collision() -> void:
	if not preview_sprite:
		return

	var mouse_pos = get_global_mouse_position()
	var current_planet = Planet.get_planet()
	var preview_radius = (current_planet.texture.get_width() / 2.0) * current_planet.scale * current_zoom

	# Get all placed planets from the game node
	var game_node = get_node("%game")
	for child in game_node.get_children():
		# Check if this is a planet node (has planet_resource property)
		if child.has_method("get") and child.get("planet_resource") != null:
			var placed_planet_resource = child.planet_resource

			# Get the planet sprite position from the PathFollow2D node (in global space)
			var planet_sprite_pos = child.global_position  # Default to base position
			if child.has_node("orbit/orbitPath/planet"):
				planet_sprite_pos = child.get_node("orbit/orbitPath/planet").global_position

			# Calculate the placed planet's radius (accounting for zoom)
			var placed_planet_radius = (placed_planet_resource.texture.get_width() / 2.0) * placed_planet_resource.scale * current_zoom

			# Calculate distance between centers
			var distance = mouse_pos.distance_to(planet_sprite_pos)

			# Check if radii are overlapping
			if distance < (preview_radius + placed_planet_radius):
				Planet.can_place = false
				return


func check_binButton_collision() -> void:
	if not bin_button:
		return
	
	var mouse_pos = get_global_mouse_position()
	if bin_button.get_global_rect().has_point(mouse_pos):
		Planet.can_place = false


func _input(event: InputEvent) -> void:
	# Mouse wheel zoom (desktop)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			# Zoom in
			var new_zoom = target_zoom + zoom_speed
			if new_zoom <= max_zoom:
				target_zoom = new_zoom
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			# Zoom out
			var new_zoom = target_zoom - zoom_speed
			if new_zoom >= min_zoom:
				target_zoom = new_zoom
	
	# Touch zoom (mobile)
	elif event is InputEventScreenTouch:
		if event.pressed:
			touch_points[event.index] = event.position
		else:
			touch_points.erase(event.index)
			last_pinch_distance = 0.0
	
	elif event is InputEventScreenDrag:
		touch_points[event.index] = event.position
		
		# Pinch to zoom with two fingers
		if touch_points.size() == 2:
			var touch_indices = touch_points.keys()
			var distance = touch_points[touch_indices[0]].distance_to(touch_points[touch_indices[1]])
			
			if last_pinch_distance > 0:
				var distance_change = distance - last_pinch_distance
				# Adjust zoom based on pinch
				var zoom_change = distance_change * 0.001  # Sensitivity factor
				var new_zoom = target_zoom + zoom_change
				new_zoom = clamp(new_zoom, min_zoom, max_zoom)
				target_zoom = new_zoom
			
			last_pinch_distance = distance


func button_mouse_entered() -> void:
	pass # Replace with function body.
