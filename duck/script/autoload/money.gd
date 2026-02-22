extends Node

var current_money: float = 1.0

signal money_changed(new_amount: float)
signal money_added(amount: float)
signal money_spent(amount: float)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Add money to the system
func add_money(amount: float) -> void:
	if amount < 0:
		return
	current_money += amount
	money_changed.emit(current_money)
	money_added.emit(amount)
	print("Money added: ", amount, ". Total: ", current_money)


# Spend/deduct money from the system
func spend_money(amount: float) -> bool:
	if amount < 0:
		return false
	
	if current_money >= amount:
		current_money -= amount
		money_changed.emit(current_money)
		money_spent.emit(amount)
		print("Money spent: ", amount, ". Remaining: ", current_money)
		return true
	else:
		print("Insufficient funds. Current: ", current_money, " Required: ", amount)
		return false


# Get the current money amount
func get_money() -> float:
	return current_money


# Set the money to a specific amount
func set_money(amount: float) -> void:
	if amount < 0:
		return
	current_money = amount
	money_changed.emit(current_money)
	print("Money set to: ", current_money)


# Reset money to 0
func reset_money() -> void:
	current_money = 0.0
	money_changed.emit(current_money)
	print("Money reset to 0")
