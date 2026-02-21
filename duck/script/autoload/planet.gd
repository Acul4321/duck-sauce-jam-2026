extends Node

# List of available planet resources
var planets: Array[PlanetClass] = []
var current_planet_index: int = 0
var current_planet: PlanetClass
var mouse_over_planet: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load all available planets
	planets.append(preload("res://scene/planet/resource/pluto.tres")) # 0.015
	planets.append(preload("res://scene/planet/resource/moon.tres")) # 0.018
	planets.append(preload("res://scene/planet/resource/mercury.tres")) # 0.022
	planets.append(preload("res://scene/planet/resource/mars.tres")) # 0.030
	planets.append(preload("res://scene/planet/resource/venus.tres")) # 0.038
	planets.append(preload("res://scene/planet/resource/earth.tres")) # 0.046
	planets.append(preload("res://scene/planet/resource/neptune.tres")) # 0.54
	planets.append(preload("res://scene/planet/resource/uranus.tres")) # 0.062
	planets.append(preload("res://scene/planet/resource/saturn.tres")) # 0.08
	planets.append(preload("res://scene/planet/resource/jupiter.tres")) # 0.088
	planets.append(preload("res://scene/planet/resource/sun.tres")) # 0.105
	
	# Set earth as default
	current_planet_index = 0
	current_planet = planets[current_planet_index]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		previous_planet()
	elif Input.is_action_just_pressed("ui_right"):
		next_planet()


# Switch to next planet
func next_planet() -> void:
	current_planet_index = (current_planet_index + 1) % planets.size()
	current_planet = planets[current_planet_index]
	print("Switched to planet: ", current_planet)


# Switch to previous planet
func previous_planet() -> void:
	current_planet_index = (current_planet_index - 1) % planets.size()
	current_planet = planets[current_planet_index]
	print("Switched to planet: ", current_planet)


# Set the current planet to use for placement
func set_planet(planet_resource: PlanetClass) -> void:
	current_planet = planet_resource


# Get the current planet resource
func get_planet() -> PlanetClass:
	return current_planet


# Get the index of a planet resource in the planets array
func get_planet_index(planet_resource: PlanetClass) -> int:
	return planets.find(planet_resource)


# Helper function to create and configure a planet node
func _create_planet_node(planet_resource: PlanetClass, position: Vector2, progress: float = 0.0) -> Node2D:
	var planet_scene = preload("res://scene/planet/planet.tscn")
	var new_planet = planet_scene.instantiate()
	new_planet.planet_resource = planet_resource
	new_planet.global_position = position
	
	# Calculate the initial rotation based on orbit direction
	var initial_rotation = atan2(position.y, position.x)
	
	# Apply planet properties
	if new_planet.has_node("orbit/orbitPath/planet"):
		var sprite = new_planet.get_node("orbit/orbitPath/planet")
		sprite.texture = planet_resource.texture
		sprite.rotation = initial_rotation
		sprite.scale = Vector2(planet_resource.scale, planet_resource.scale)
	
	# Set orbit dimensions and initial rotation
	if new_planet.has_node("orbitGhost"):
		var orbit_ghost = new_planet.get_node("orbitGhost")
		orbit_ghost.a = planet_resource.a
		orbit_ghost.b = planet_resource.b
		orbit_ghost.lerped_rotation = initial_rotation
	
	if new_planet.has_node("orbit"):
		var orbit = new_planet.get_node("orbit")
		if orbit.has_node("orbitPath"):
			var path_follow = orbit.get_node("orbitPath")
			path_follow.speed = planet_resource.speed
			path_follow.progress = progress
		orbit.a = planet_resource.a
		orbit.b = planet_resource.b
	
	return new_planet
