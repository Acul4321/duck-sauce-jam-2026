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
	var current_planet = Planet.get_planet()
	var new_planet = Planet._create_planet_node(current_planet, mouse_pos)
	add_child(new_planet)
