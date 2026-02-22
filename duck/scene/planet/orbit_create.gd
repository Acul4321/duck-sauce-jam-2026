extends Path2D

@export var a : float = 200.0
@export var b : float = 120.0
@export var resolution : int = 100

var orbit_line: Line2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_orbit_curve()
	create_orbit_line()
	create_instantiation_marker()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_orbit_curve() -> void:
	var planet_pos = get_parent().position  # Use local position instead of global
	var angle_to_placement = atan2(planet_pos.y, planet_pos.x)
	var distance_to_origin = planet_pos.length()
	
	# Calculate scale factors to make ellipse pass through planet position
	var scale_factor = distance_to_origin / a
	
	var curve = Curve2D.new()

	for i in range(resolution + 1):
		var t = float(i) / resolution * TAU
		var point = Vector2(a * cos(t) * scale_factor, b * sin(t) * scale_factor)
		var rotated = point.rotated(angle_to_placement)
		# Offset to center orbit at game origin (0,0)
		# planet_pos is the planet's position in game space, so subtract it to get curve points relative to the Path2D
		var offset_point = rotated - planet_pos
		curve.add_point(offset_point)

	self.curve = curve


func create_orbit_line() -> void:
	# Create a Line2D to visualize the orbit path
	orbit_line = Line2D.new()
	orbit_line.width = 1.0
	orbit_line.default_color = Color(1, 1, 1, 0.3)  # Semi-transparent white
	
	# Add points from the curve to the line
	if self.curve:
		for i in range(self.curve.point_count):
			var point = self.curve.get_point_position(i)
			orbit_line.add_point(point)
	
	add_child(orbit_line)


func create_instantiation_marker() -> void:
	# Create a small circle marker at the planet's instantiation point
	var marker = Node2D.new()
	var circle_radius = 3.0
	
	# Draw the circle using a Polygon2D for better performance
	var circle = Polygon2D.new()
	var points: PackedVector2Array = []
	var circle_segments = 16
	
	for i in range(circle_segments + 1):
		var angle = (float(i) / circle_segments) * TAU
		points.append(Vector2(cos(angle), sin(angle)) * circle_radius)
	
	circle.polygon = points
	circle.color = Color(1, 0.8, 0, 0.8)  # Yellow/orange semi-transparent
	
	# Get the planet's current position relative to this Path2D
	var planet_pos = get_parent().position  # Use local position instead of global
	marker.position = planet_pos
	
	marker.add_child(circle)
	orbit_line.add_child(marker)
