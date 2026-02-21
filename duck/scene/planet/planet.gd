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
	#if area.owner is Node2D and area.owner.has_method("_ready"):
		#print("Planet collision ended with: ", area.owner.name)
		pass


func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.owner is Node2D and area.owner.has_method("_ready"):
		print("Planet collision detected with: ", area.owner.name)
		
		# Get the two planet positions and calculate midpoint
		var this_pos = global_position
		var other_pos = area.owner.global_position
		var midpoint = (this_pos + other_pos) / 2.0
		
		# Remove the colliding planets immediately
		area.owner.free()
		self.queue_free()
		
		# Get next planet and create it at the midpoint
		Planet.next_planet()
		var next_planet_resource = Planet.get_planet()
		var new_planet = Planet._create_planet_node(next_planet_resource, midpoint)
		
		# Add to scene
		get_parent().add_child(new_planet)
