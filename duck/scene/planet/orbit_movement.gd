extends PathFollow2D

@export var speed : float = 100.0

var previous_progress_ratio: float = 0.0

func _process(delta):
	progress += speed * delta
	
	# Detect when planet completes a full loop
	var current_progress_ratio = progress_ratio
	if current_progress_ratio < previous_progress_ratio:  # Wrapped around from ~1.0 to ~0.0
		# Get the planet resource and add its reward
		var planet_node = get_parent().get_parent()
		if planet_node and "planet_resource" in planet_node:
			var reward = planet_node.planet_resource.reward
			Money.add_money(reward)
	
	previous_progress_ratio = current_progress_ratio
	
	# Apply lerped rotation to planet sprite from orbit_ghost
	var orbit_ghost = get_parent().get_parent().get_node_or_null("orbitGhost")
	if orbit_ghost:
		var planet_sprite = get_node_or_null("planet")
		if planet_sprite:
			planet_sprite.rotation = orbit_ghost.lerped_rotation
