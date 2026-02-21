extends Node2D

var planet_resource: PlanetClass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get the planet resource
	if not planet_resource:
		planet_resource = Planet.get_planet()
	
	# Configure the Area2D for collision detection
	if has_node("Area2D"):
		var area = get_node("Area2D")
		# Set collision layers - planets are on layer 1
		area.collision_layer = 1
		area.collision_mask = 1
		area.scale = Vector2(planet_resource.scale, planet_resource.scale)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.owner is Node2D and area.owner.has_method("_ready"):
		print("Planet collision ended with: ", area.owner.name)


func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.owner is Node2D and area.owner.has_method("_ready"):
		print("Planet collision detected with: ", area.owner.name)
