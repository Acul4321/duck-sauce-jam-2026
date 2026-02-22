extends Sprite2D

@export var rotation_speed := 0.25

func _process(delta: float) -> void:
	rotate(rotation_speed * delta)
