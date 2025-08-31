extends Node2D
class_name World

# Constant parameters
const Rope = preload("res://Scenes/rope.tscn")
const Liekki = preload("res://Scenes/liekki.tscn")
const YouDied = preload("res://Scenes/you_died.tscn")
# Export variables
# Onready variables
@onready var camera: Camera2D = $Camera
@onready var rope: Node2D = $Rope
@onready var lava: Node2D = $Lava
@onready var death_timer: Timer = $DeathTimer
@onready var song_gameplay: AudioStreamPlayer = $SongGameplay
@onready var song_gameplay_intro: AudioStreamPlayer = $SongGameplayIntro
# Variables
var camera_location: Vector2
var camera_speed := Configs.CAMERA_SPEED
var camera_timer := 0.0
var lava_offset: float
var rope_location: Vector2
var dead: bool = false


# Custom functions

func death(death_position: Vector2) -> void:
	# Play Liekki FX
	var liekki = Liekki.instantiate()
	var you_died = YouDied.instantiate()
	add_child(liekki, true)
	liekki.global_position = death_position
	if not dead:
		add_child(you_died, true)
	
	# Start timer
	you_died.global_position = camera.global_position

	dead = true

	if death_timer.is_stopped():
		death_timer.start()
	

func _on_death_timer_timeout() -> void:
	# Reset camera and lava position
	camera.global_position = camera_location
	lava.global_position.y = camera.global_position.y + lava_offset
	camera_speed = Configs.CAMERA_SPEED
	camera_timer = 0.0

	# Reset rope position
	call_deferred("spawn_players")


func spawn_players() -> void:
	# Remove unnecessary nodes
	var children = get_children()
	for child in children:
		if child.name.begins_with("Liekki"):
			child.queue_free()
		if child.name.begins_with("YouDied"):
			child.queue_free()
	rope.queue_free()
	rope = Rope.instantiate()
	add_child(rope)
	rope.global_position = rope_location
	song_gameplay.stop()
	song_gameplay_intro.play()
	song_gameplay.volume_db = 0.0
	dead = false

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

	# If dead, fade out music in 2 secs
	if dead:
		song_gameplay.volume_db -= 10*delta
		if song_gameplay.volume_db < -79:
			song_gameplay.stop()


func _on_song_gameplay_intro_finished() -> void:
	song_gameplay.play()
