extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect to the Money singleton's money_changed signal
	Money.money_changed.connect(_on_money_changed)
	
	# Set initial text
	text = str(int(Money.get_money()))
 

# Called when money changes
func _on_money_changed(new_amount: float) -> void:
	text = str(int(new_amount))
