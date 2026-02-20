extends Node2D

@export var a : float = 200.0
@export var b : float = 120.0
@export var resolution : int = 100

func _ready() -> void:
	queue_redraw()

func _process(_delta: float) -> void:
	queue_redraw()

func _draw():
	var planet_pos = get_parent().global_position
	var angle_to_planet = atan2(planet_pos.y, planet_pos.x)
	var distance_to_origin = planet_pos.length()
	
	# Calculate scale factors to make ellipse pass through planet position
	var scale_factor = distance_to_origin / a
	
	var points = []

	for i in range(resolution + 1):
		var t = float(i) / resolution * TAU
		var point = Vector2(a * cos(t) * scale_factor, b * sin(t) * scale_factor)
		# Rotate the ellipse so it aligns with the planet position
		var rotated = point.rotated(angle_to_planet)
		# Offset to center orbit at world origin (0,0)
		var offset_point = rotated - global_position
		points.append(offset_point)

	draw_polyline(points, Color.WHITE, 0.5, true)
