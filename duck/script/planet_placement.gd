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
	add_child(new_planet)
