extends Node2D

var planet_scene = preload("res://scene/planet/planet.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		spawn_planet_at_mouse()


func spawn_planet_at_mouse() -> void:
	var mouse_pos = get_global_mouse_position()
	var new_planet = planet_scene.instantiate()
	new_planet.global_position = mouse_pos
	
	# Calculate the initial rotation based on orbit direction
	var initial_rotation = atan2(mouse_pos.y, mouse_pos.x)
	
	# Get current planet from singleton
	var current_planet = Planet.get_planet()
	
	# Apply planet properties
	if new_planet.has_node("orbit/orbitPath/planet"):
		var sprite = new_planet.get_node("orbit/orbitPath/planet")
		sprite.texture = current_planet.texture
		sprite.rotation = initial_rotation
		sprite.scale = Vector2(current_planet.scale, current_planet.scale)
	
	# Set orbit dimensions and initial rotation
	if new_planet.has_node("orbitGhost"):
		var orbit_ghost = new_planet.get_node("orbitGhost")
		orbit_ghost.a = current_planet.a
		orbit_ghost.b = current_planet.b
		orbit_ghost.lerped_rotation = initial_rotation
	
	if new_planet.has_node("orbit"):
		var orbit = new_planet.get_node("orbit")
		if orbit.has_node("orbitPath"):
			orbit.get_node("orbitPath").speed = current_planet.speed
		orbit.a = current_planet.a
		orbit.b = current_planet.b
	
	add_child(new_planet)
