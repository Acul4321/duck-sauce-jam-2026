extends Node2D

@export var shopPopup: ShopPopup
@export var menuPlayer: AudioStreamPlayer
@export var sfxOpenPopup: AudioStream
@export var sfxClosePopup: AudioStream


func openPopup():
	menuPlayer.stream = sfxOpenPopup
	menuPlayer.play(0.5)
	shopPopup.show()


func _on_pluto_pressed() -> void:
	shopPopup.planet = $Pluto.planet
	openPopup()


func _on_neptune_pressed() -> void:
	shopPopup.planet = $Neptune.planet
	openPopup()


func _on_jupiter_pressed() -> void:
	shopPopup.planet = $Jupiter.planet
	openPopup()


func _on_earth_pressed() -> void:
	shopPopup.planet = $Earth.planet
	openPopup()


func _on_mercury_pressed() -> void:
	shopPopup.planet = $Mercury.planet
	openPopup()


func _on_mars_pressed() -> void:
	shopPopup.planet = $Mars.planet
	openPopup()


func _on_venus_pressed() -> void:
	shopPopup.planet = $Venus.planet
	openPopup()


func _on_uranus_pressed() -> void:
	shopPopup.planet = $Uranus.planet
	openPopup()


func _on_saturn_pressed() -> void:
	shopPopup.planet = $Saturn.planet
	openPopup()


func _on_moon_pressed() -> void:
	shopPopup.planet = $Moon.planet
	openPopup()


func _on_sun_pressed() -> void:
	shopPopup.planet = $Sun.planet
	openPopup()


func _on_shop_popup_close() -> void:
	menuPlayer.stream = sfxClosePopup
	menuPlayer.play(0.005)
