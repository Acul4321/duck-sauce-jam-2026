extends Node

class_name MusicManager

@export var shop: AudioStreamPlayer
@export var main: AudioStreamPlayer

var current := "main"


func toggle(scene := ""):
	if !scene.is_empty(): current = scene
	var tweenUp = create_tween()
	var tweenDown = create_tween()
	print("Music set to: " + current)
	if current == "main":
		tweenUp.tween_property(main, ^"volume_db", -80.0, 1.0)
		tweenDown.tween_property(shop, ^"volume_db", 0.0, 1.0)
		current = "shop"
	else:
		tweenUp.tween_property(shop, ^"volume_db", -80.0, 1.0)
		tweenDown.tween_property(main, ^"volume_db", 0.0, 1.0)
		current = "main"
