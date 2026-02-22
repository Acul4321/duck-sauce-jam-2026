extends Node2D

@export var shopPopup: ShopPopup

func _ready() -> void:
	# Array of buttons in tier order (matching Planet.planets array)
	var planet_buttons = [$Pluto, $Moon, $Mercury, $Mars, $Venus, $Earth, $Neptune, $Uranus, $Saturn, $Jupiter, $Sun]
	
	# Get the highest tier planet currently orbiting
	var highest_tier = Planet.get_highest_orbiting_planet_tier()
	
	# Set shop popup to highest tier planet, or Pluto as default
	if highest_tier >= 0 and highest_tier < planet_buttons.size():
		shopPopup.planet = planet_buttons[highest_tier].planet
	else:
		shopPopup.planet = $Pluto.planet
	
	shopPopup.show()


func _process(delta: float) -> void:
	# Check and update each planet button's enabled/disabled state
	_update_button_state($Pluto)
	_update_button_state($Neptune)
	_update_button_state($Jupiter)
	_update_button_state($Earth)
	_update_button_state($Mercury)
	_update_button_state($Mars)
	_update_button_state($Venus)
	_update_button_state($Uranus)
	_update_button_state($Saturn)
	_update_button_state($Moon)
	_update_button_state($Sun)


func _update_button_state(button: PlanetButton) -> void:
	if button and button.planet:
		# Get the current count of this planet type orbiting
		var current_count = Planet.get_planet_count(button.planet)
		# Get the tier (index) of this planet
		var planet_tier = Planet.get_planet_index(button.planet)
		# Get the highest tier planet currently orbiting
		var highest_tier = Planet.get_highest_orbiting_planet_tier()
		
		# Enable if: we have enough of this planet type OR this planet is at/below highest tier
		button.disabled = not (current_count >= button.planet.required or planet_tier <= highest_tier)


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
