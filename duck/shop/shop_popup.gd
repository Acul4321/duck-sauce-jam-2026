extends Node2D

class_name ShopPopup

@export var planetImage: Sprite2D
@export var planetCost: Label
@export var planetName: Label

var planet: PlanetClass:
	set(value):
		planet = value
		planetImage.texture = planet.texture
		planetName.text = planet.name
		planetCost.text = str(planet.cost,"x")

func _process(_delta: float) -> void:
	if(Input.is_key_pressed(KEY_ESCAPE)):
		hide()
