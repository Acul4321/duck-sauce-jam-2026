extends Node2D

@export var shopPopup: ShopPopup

func _ready() -> void:
	shopPopup.planet = $Pluto.planet
	shopPopup.show()


func _on_pluto_pressed() -> void:
	shopPopup.planet = $Pluto.planet
	shopPopup.show()


func _on_neptune_pressed() -> void:
	shopPopup.planet = $Neptune.planet
	shopPopup.show()


func _on_jupiter_pressed() -> void:
	shopPopup.planet = $Jupiter.planet
	shopPopup.show()


func _on_earth_pressed() -> void:
	shopPopup.planet = $Earth.planet
	shopPopup.show()


func _on_mercury_pressed() -> void:
	shopPopup.planet = $Mercury.planet
	shopPopup.show()


func _on_mars_pressed() -> void:
	shopPopup.planet = $Mars.planet
	shopPopup.show()


func _on_venus_pressed() -> void:
	shopPopup.planet = $Venus.planet
	shopPopup.show()


func _on_uranus_pressed() -> void:
	shopPopup.planet = $Uranus.planet
	shopPopup.show()


func _on_saturn_pressed() -> void:
	shopPopup.planet = $Saturn.planet
	shopPopup.show()


func _on_moon_pressed() -> void:
	shopPopup.planet = $Moon.planet
	shopPopup.show()


func _on_sun_pressed() -> void:
	shopPopup.planet = $Sun.planet
	shopPopup.show()
