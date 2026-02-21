extends Node2D

class_name ShopPopup

var planet: PlanetClass:
	set(value):
		planet = value
		# Set the picture and the price

func _process(_delta: float) -> void:
	if(Input.is_key_pressed(KEY_ESCAPE)):
		hide()
