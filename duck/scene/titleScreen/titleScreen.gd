extends Node

@onready var buttons = $Buttons
@onready var MainGame = $Buttons/MainGame
@onready var Setting = $Buttons/Setting
@onready var QuitGame = $Buttons/QuitGame

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MainGame.pressed.connect(_mainGame)
	QuitGame.pressed.connect(_quitGame)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _mainGame():
	get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(main))

func _quitGame():
	get_tree().quit()
