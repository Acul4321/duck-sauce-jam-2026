extends Node

# List of available planet resources
var planets: Array[PlanetClass] = []
var current_planet_index: int = 0
var current_planet: PlanetClass
var mouse_over_planet: bool = false
var can_place: bool = true
var place_mode: bool = false

# Dictionary to track how many of each planet type are currently orbiting
# Key: planet name (String), Value: count (int)
var orbiting_planets: Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load all available planets
	planets.append(preload("res://scene/planet/resource/pluto.tres")) # Speed 200
	planets.append(preload("res://scene/planet/resource/moon.tres")) # Speed 190
	planets.append(preload("res://scene/planet/resource/mercury.tres")) # Speed 180
	planets.append(preload("res://scene/planet/resource/mars.tres")) # Speed 170
	planets.append(preload("res://scene/planet/resource/venus.tres")) # Speed 160
	planets.append(preload("res://scene/planet/resource/earth.tres")) # Speed 150
	planets.append(preload("res://scene/planet/resource/neptune.tres")) # Speed 140
	planets.append(preload("res://scene/planet/resource/uranus.tres")) # Speed 127
	planets.append(preload("res://scene/planet/resource/saturn.tres")) # Speed 110
	planets.append(preload("res://scene/planet/resource/jupiter.tres")) # Speed 080
	planets.append(preload("res://scene/planet/resource/sun.tres")) # Speed 050
	
	# Set pluto as default
	current_planet_index = 0
	current_planet = planets[current_planet_index]


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


# Add a planet to the orbiting count
func add_orbiting_planet(planet_resource: PlanetClass) -> void:
	var planet_name = planet_resource.name
	if not orbiting_planets.has(planet_name):
		orbiting_planets[planet_name] = 0
	orbiting_planets[planet_name] += 1
	print("Added ", planet_name, ". Total: ", orbiting_planets[planet_name])


# Remove a planet from the orbiting count
func remove_orbiting_planet(planet_resource: PlanetClass) -> void:
	var planet_name = planet_resource.name
	if orbiting_planets.has(planet_name) and orbiting_planets[planet_name] > 0:
		orbiting_planets[planet_name] -= 1
		print("Removed ", planet_name, ". Total: ", orbiting_planets[planet_name])


# Get count of a specific planet type
func get_planet_count(planet_resource: PlanetClass) -> int:
	var planet_name = planet_resource.name
	if orbiting_planets.has(planet_name):
		return orbiting_planets[planet_name]
	return 0


# Get total count of all orbiting planets
func get_total_planet_count() -> int:
	var total = 0
	for count in orbiting_planets.values():
		total += count
	return total


# Get the highest tier planet index currently orbiting
# Returns the index in the planets array, or -1 if no planets are orbiting
func get_highest_orbiting_planet_tier() -> int:
	var highest_tier = -1
	for planet_name in orbiting_planets.keys():
		if orbiting_planets[planet_name] > 0:
			# Find this planet in the planets array
			for i in range(planets.size()):
				if planets[i].name == planet_name:
					highest_tier = max(highest_tier, i)
					break
	return highest_tier


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
	
	# Connect to the planet's tree_exiting signal to track when it's removed
	new_planet.tree_exiting.connect(_on_planet_removed.bind(planet_resource))
	
	# Track this planet as orbiting
	add_orbiting_planet(planet_resource)
	
	return new_planet


# Called when a planet is removed from the scene tree
func _on_planet_removed(planet_resource: PlanetClass) -> void:
	remove_orbiting_planet(planet_resource)
