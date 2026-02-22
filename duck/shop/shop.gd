extends Node2D

@export var shopPopup: ShopPopup
@export var menuPlayer: AudioStreamPlayer
@export var sfxOpenPopup: AudioStream
@export var sfxClosePopup: AudioStream


func openPopup():
	menuPlayer.stream = sfxOpenPopup
	menuPlayer.play(0.5)
	shopPopup.show()

func _ready() -> void:
	# Initialize last selected planet to Pluto if not set
	if Planet.last_shop_planet == null:
		Planet.last_shop_planet = $Pluto.planet
	
	shopPopup.planet = Planet.last_shop_planet
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
		# Get the tier (index) of this planet
		var planet_tier = Planet.get_planet_index(button.planet)
		var planet_name = button.planet.name
		
		# Check if already unlocked
		if Planet.unlocked_planets.has(planet_name) and Planet.unlocked_planets[planet_name]:
			button.disabled = false
			return
		
		# Check if there's a higher tier planet
		var next_tier = planet_tier + 1
		if next_tier < Planet.planets.size():
			# Get the next higher tier planet
			var next_planet = Planet.planets[next_tier]
			# Get the count of the next higher tier planet
			var next_planet_count = Planet.get_planet_count(next_planet)
			
			# Check if requirements met to unlock
			if next_planet_count >= button.planet.required:
				# Unlock this planet permanently
				Planet.unlocked_planets[planet_name] = true
				button.disabled = false
			else:
				button.disabled = true
		elif Planet.get_highest_orbiting_planet_tier() == Planet.planets.size() - 1:
			# Last tier planet is always available
			Planet.unlocked_planets[planet_name] = true
			button.disabled = false
		else:
			# No higher tier, so just check if this one is unlocked
			button.disabled = true

func _on_pluto_pressed() -> void:
	shopPopup.planet = $Pluto.planet
	Planet.last_shop_planet = $Pluto.planet
	openPopup()


func _on_neptune_pressed() -> void:
	shopPopup.planet = $Neptune.planet
	Planet.last_shop_planet = $Neptune.planet
	openPopup()


func _on_jupiter_pressed() -> void:
	shopPopup.planet = $Jupiter.planet
	Planet.last_shop_planet = $Jupiter.planet
	openPopup()


func _on_earth_pressed() -> void:
	shopPopup.planet = $Earth.planet
	Planet.last_shop_planet = $Earth.planet
	openPopup()


func _on_mercury_pressed() -> void:
	shopPopup.planet = $Mercury.planet
	Planet.last_shop_planet = $Mercury.planet
	openPopup()


func _on_mars_pressed() -> void:
	shopPopup.planet = $Mars.planet
	Planet.last_shop_planet = $Mars.planet
	openPopup()


func _on_venus_pressed() -> void:
	shopPopup.planet = $Venus.planet
	Planet.last_shop_planet = $Venus.planet
	openPopup()


func _on_uranus_pressed() -> void:
	shopPopup.planet = $Uranus.planet
	Planet.last_shop_planet = $Uranus.planet
	openPopup()


func _on_saturn_pressed() -> void:
	shopPopup.planet = $Saturn.planet
	Planet.last_shop_planet = $Saturn.planet
	openPopup()


func _on_moon_pressed() -> void:
	shopPopup.planet = $Moon.planet
	Planet.last_shop_planet = $Moon.planet
	openPopup()


func _on_sun_pressed() -> void:
	shopPopup.planet = $Sun.planet
	Planet.last_shop_planet = $Sun.planet
	openPopup()


func _on_shop_popup_close() -> void:
	menuPlayer.stream = sfxClosePopup
	menuPlayer.play(0.005)
