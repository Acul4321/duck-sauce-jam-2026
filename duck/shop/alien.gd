extends Node2D

@export var sfxSpeak: AudioStream
@export var sfxNo: AudioStream
@export var sfxBuy: AudioStream
@export var sfxHello: AudioStream
@export var chatterPlayer: AudioStreamPlayer
@export var chatterTimer: Timer


func _on_chatter_timer_timeout() -> void:
	chatterPlayer.play()
	chatterTimer.start(randi_range(7, 12))
