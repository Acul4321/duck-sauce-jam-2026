extends Node2D

@export var a : float
@export var b : float 
@export var resolution : int = 100

func _ready() -> void:
	queue_redraw()
	a = Planet.current_planet.a
	b = Planet.current_planet.b

func _process(_delta: float) -> void:
	queue_redraw()
	a = Planet.current_planet.a
	b = Planet.current_planet.b

func _draw():
	var mouse_pos = get_global_mouse_position()
	var angle_to_mouse = atan2(mouse_pos.y, mouse_pos.x)
	var distance_to_origin = mouse_pos.length()
	
	# Calculate scale factors to make ellipse pass through mouse position
	var scale_factor = distance_to_origin / a
	
	var points = []

	for i in range(resolution + 1):
		var t = float(i) / resolution * TAU
		var point = Vector2(a * cos(t) * scale_factor, b * sin(t) * scale_factor)
		# Rotate the ellipse so it aligns with the mouse position
		var rotated = point.rotated(angle_to_mouse)
		points.append(rotated)

	draw_polyline(points, Color.WHITE, 0.5, true)
