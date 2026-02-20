extends Path2D

@export var a : float = 200.0
@export var b : float = 120.0
@export var resolution : int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_orbit_curve()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_orbit_curve() -> void:
	var planet_pos = get_parent().global_position
	var angle_to_placement = atan2(planet_pos.y, planet_pos.x)
	var distance_to_origin = planet_pos.length()
	
	# Calculate scale factors to make ellipse pass through planet position
	var scale_factor = distance_to_origin / a
	
	var curve = Curve2D.new()

	for i in range(resolution + 1):
		var t = float(i) / resolution * TAU
		var point = Vector2(a * cos(t) * scale_factor, b * sin(t) * scale_factor)
		var rotated = point.rotated(angle_to_placement)
		# Offset to center orbit at world origin (0,0)
		var offset_point = rotated - global_position
		curve.add_point(offset_point)

	self.curve = curve
