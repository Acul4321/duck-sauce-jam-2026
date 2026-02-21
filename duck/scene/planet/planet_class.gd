extends Resource
class_name PlanetClass

@export var texture: Texture2D
@export var a: float = 200.0  # semi-major axis (horizontal radius)
@export var b: float = 120.0  # semi-minor axis (vertical radius)
@export var speed: float = 100.0  # orbit speed
@export var scale: float = 0.029  # sprite scale

@export var name: String
@export var cost: int
@export var reward: float = 1.0 # money given per orbit
@export var required: int = 1 # the number of planets needed to unlock the planet in the shop
