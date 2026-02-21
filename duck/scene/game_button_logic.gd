extends Control

@onready var shop_button: Button = $ShopButton
@onready var bin_icon: Button = $BinIcon
@onready var shop_scene = preload("res://shop/shop.tscn")
var shop_instance: Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Toggle button visibility based on place_mode
	if Planet.place_mode:
		shop_button.visible = false
		bin_icon.visible = true
	else:
		shop_button.visible = true
		bin_icon.visible = false


func _on_shop_button_pressed() -> void:
	if shop_instance and is_instance_valid(shop_instance):
		shop_instance.queue_free()
		shop_instance = null
		return
	
	shop_instance = shop_scene.instantiate()
	get_tree().current_scene.add_child(shop_instance)
	shop_instance.scale = Vector2.ONE * 0.98
	shop_instance.z_as_relative = false
	shop_instance.z_index = 100
	
	var viewport_center = Vector2(10,10) 
	if shop_instance.has_node("Background"):
		var bg = shop_instance.get_node("Background")
		shop_instance.position = viewport_center - bg.position
	else:
		shop_instance.position = viewport_center


func _on_bin_icon_pressed() -> void:
	pass # Replace with function body.


func button_mouse_entered() -> void:
	pass # Replace with function body.


func button_mouse_exited() -> void:
	pass # Replace with function body.
