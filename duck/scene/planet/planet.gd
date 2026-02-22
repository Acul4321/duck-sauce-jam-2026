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
		
		# Check if both planets are the same type
		var other_planet_resource = area.owner.planet_resource
		if not other_planet_resource:
			return
		
		# If different planet types, destroy the smaller one
		if planet_resource != other_planet_resource:
			var this_index = Planet.get_planet_index(planet_resource)
			var other_index = Planet.get_planet_index(other_planet_resource)
			
			if this_index < other_index:
				# This planet is smaller, destroy it
				self.queue_free()
			elif other_index < this_index:
				# Other planet is smaller, destroy it
				area.owner.queue_free()
			
			print("Different planet types - smaller planet destroyed")
			return
		
		# Get the two planet positions and calculate midpoint
		var this_pos = global_position
		var other_pos = area.owner.global_position
		var midpoint = (this_pos + other_pos) / 2.0
		
		# Get current progress from both planets' PathFollow2D
		var this_progress = 0.0
		var other_progress = 0.0
		
		if has_node("orbit/orbitPath"):
			var path_follow = get_node("orbit/orbitPath")
			this_progress = path_follow.progress
		
		if area.owner.has_node("orbit/orbitPath"):
			var other_path_follow = area.owner.get_node("orbit/orbitPath")
			other_progress = other_path_follow.progress
		
		# Average the progress values
		var avg_progress = (this_progress + other_progress) / 2.0
		
		# Remove the colliding planets immediately
		area.owner.free()
		self.queue_free()
		
		# Get next tier planet without modifying the global current planet
		var next_planet_resource = Planet.get_next_tier_planet(planet_resource)
		var new_planet = Planet._create_planet_node(next_planet_resource, midpoint, avg_progress)
		
		# Add to scene
		get_parent().add_child(new_planet)
