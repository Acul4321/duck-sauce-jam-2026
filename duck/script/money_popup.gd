extends Label

var float_speed: float = 50.0
var fade_duration: float = 1.0
var time_elapsed: float = 0.0

func _ready() -> void:
	# Start with full opacity
	modulate.a = 1.0
	
	# Create a tween to fade out and move up
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	
	# Fade out over fade_duration
	tween.tween_property(self, "modulate:a", 0.0, fade_duration)
	
	# Move up over fade_duration
	tween.tween_property(self, "position:y", position.y - float_speed, fade_duration)
	
	# Delete after animation completes
	await tween.finished
	queue_free()
