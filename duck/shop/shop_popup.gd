extends Node2D

class_name ShopPopup

signal close

@export var planetImage: Sprite2D
@export var planetCost: Label
@export var planetName: Label
@export var buyButton: BuyButton

var planet: PlanetClass:
	set(value):
		planet = value
		planetImage.texture = planet.texture
		planetName.text = planet.name
		planetCost.text = str(planet.cost,"x")

func _ready() -> void:
	if buyButton:
		buyButton.buy_pressed.connect(_on_buy_pressed)

func _on_buy_pressed() -> void:
	# Check if player has enough money
	if Money.get_money() >= planet.cost:
		# Deduct the cost
		Money.spend_money(planet.cost)
		# Set the planet to place
		Planet.set_planet(planet)
		# Enter place mode
		Planet.place_mode = true
		# Close the shop using the same logic as game_button_logic
		_close_shop()
	else:
		print("Not enough money!")

func _close_shop() -> void:
	var shop = get_parent()
	if shop and is_instance_valid(shop):
		shop.queue_free()

func _process(_delta: float) -> void:
	# Update buy button state based on available money
	if buyButton and planet:
		buyButton.disabled = Money.get_money() < planet.cost
	
	if(Input.is_key_pressed(KEY_ESCAPE)):
		_close_shop()
