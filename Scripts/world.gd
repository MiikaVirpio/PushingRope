extends Node2D
class_name World

# Constant parameters
const Rope = preload("res://Scenes/rope.tscn")
# Export variables
# Onready variables
@onready var camera: Camera2D = $Camera
@onready var rope: Node2D = $Rope
@onready var lava: Node2D = $Lava
# Variables
var camera_location: Vector2
var camera_speed := Configs.CAMERA_SPEED
var camera_timer := 0.0
var lava_offset: float
var rope_location: Vector2

# Custom functions

func reset_level() -> void:
	# Reset camera and lava position
	camera.global_position = camera_location
	lava.global_position.y = camera.global_position.y + lava_offset
	camera_speed = Configs.CAMERA_SPEED
	camera_timer = 0.0

	# Reset rope position
	call_deferred("spawn_players")


func spawn_players() -> void:
	rope.queue_free()
	rope = Rope.instantiate()
	add_child(rope)
	rope.global_position = rope_location


# Internal functions
func _ready() -> void:
	camera.make_current()
	rope_location = rope.global_position
	camera_location = camera.global_position
	lava_offset = lava.global_position.y - camera.global_position.y


func _process(delta: float) -> void:
	if camera_timer < Configs.CAMERA_DELAY:
		camera_timer += delta
	else:
		camera_speed = camera_speed + Configs.CAMERA_ACCELERATION * delta
		camera.global_position.y -= camera_speed * delta
		lava.global_position.y = camera.global_position.y + lava_offset

	# Bind ESC to close game
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
