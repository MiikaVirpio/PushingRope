# GDScript
extends Camera2D

@export var start_speed: float = 5.0       # pixels/sec
@export var accel: float = 0.0               # pixels/sec^2 (set >0 to ramp difficulty)
@export var max_speed: float = 300.0
@export var start_delay: float = 1.5        # seconds before scrolling starts

var _speed := 0.0
var _timer := 0.0

func _ready() -> void:
	make_current()
	_speed = start_speed

func _physics_process(delta: float) -> void:
	if _timer < start_delay:
		_timer += delta
		return

	if accel != 0.0:
		_speed = min(_speed + accel * delta, max_speed)

	# In Godot, Y increases downward. To scroll UP, move the camera up (negative Y).
	global_position.y -= _speed * delta
