extends Node2D

@export var a : float = 200.0
@export var b : float = 120.0
@export var resolution : int = 100

var lerped_rotation : float = 0.0
@export var rotation_lerp_speed : float = 0.01

func _ready() -> void:
	var planet_pos = get_parent().global_position
	lerped_rotation = atan2(planet_pos.y, planet_pos.x)
	queue_redraw()

func _process(_delta: float) -> void:
	queue_redraw()

func _draw():
	var planet_pos = get_parent().global_position
	var target_angle = atan2(planet_pos.y, planet_pos.x)
	var distance_to_origin = planet_pos.length()
	
	# Interpolate the planet's rotation smoothly
	lerped_rotation = lerp_angle(lerped_rotation, target_angle, rotation_lerp_speed)
	
	# Calculate scale factors to make ellipse pass through planet position
	var scale_factor = distance_to_origin / a
	
	var points = []

	for i in range(resolution + 1):
		var t = float(i) / resolution * TAU
		var point = Vector2(a * cos(t) * scale_factor, b * sin(t) * scale_factor)
		# Rotate the ellipse to the actual target angle (not interpolated)
		var rotated = point.rotated(target_angle)
		# Offset to center orbit at world origin (0,0)
		var offset_point = rotated - global_position
		points.append(offset_point)

	draw_polyline(points, Color.WHITE, 0.5, true)
