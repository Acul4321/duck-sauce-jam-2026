extends Node2D

@export var shopPopup: ShopPopup


func _on_pluto_pressed() -> void:
	shopPopup.planet = $Pluto.planet
	shopPopup.show()


func _on_neptune_pressed() -> void:
	shopPopup.planet = $Neptune.planet
	shopPopup.show()
