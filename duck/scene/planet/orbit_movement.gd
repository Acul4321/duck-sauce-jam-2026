extends PathFollow2D

@export var speed : float = 100.0

func _process(delta):
	progress += speed * delta
	
	# Apply lerped rotation to planet sprite from orbit_ghost
	var orbit_ghost = get_parent().get_parent().get_node_or_null("orbitGhost")
	if orbit_ghost:
		var planet_sprite = get_node_or_null("planet")
		if planet_sprite:
			planet_sprite.rotation = orbit_ghost.lerped_rotation
