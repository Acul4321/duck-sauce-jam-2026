extends Node

# List of available planet resources
var planets: Array[PlanetClass] = []
var current_planet_index: int = 0
var current_planet: PlanetClass
var mouse_over_planet: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load all available planets
	planets.append(preload("res://scene/planet/resource/earth.tres"))
	planets.append(preload("res://scene/planet/resource/neptune.tres"))
	planets.append(preload("res://scene/planet/resource/pluto.tres"))
	planets.append(preload("res://scene/planet/resource/uranus.tres"))
	planets.append(preload("res://scene/planet/resource/sun.tres"))
	
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
