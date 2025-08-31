extends Node2D
class_name World

# Constant parameters
const Rope = preload("res://Scenes/rope.tscn")
const Liekki = preload("res://Scenes/liekki.tscn")
const YouDied = preload("res://Scenes/you_died.tscn")
const YouWon = preload("res://Scenes/you_won.tscn")
# Export variables
# Onready variables
@onready var camera: Camera2D = $Camera
@onready var rope: Node2D = $Rope
@onready var lava: Node2D = $Lava
@onready var death_timer: Timer = $DeathTimer
@onready var song_gameplay: AudioStreamPlayer = $SongGameplay
@onready var song_gameplay_intro: AudioStreamPlayer = $SongGameplayIntro
@onready var spawn_point_1: Marker2D = $SpawnPoints/SpawnPoint1
@onready var camera_point_1: Marker2D = $SpawnPoints/CameraPoint1
@onready var spawn_point_2: Marker2D = $SpawnPoints/SpawnPoint2
@onready var camera_point_2: Marker2D = $SpawnPoints/CameraPoint2
@onready var spawn_point_3: Marker2D = $SpawnPoints/SpawnPoint3
@onready var camera_point_3: Marker2D = $SpawnPoints/CameraPoint3
@onready var world_environment: WorldEnvironment = $WorldEnvironment
# Variables
var camera_location: Vector2
var camera_speed := Configs.CAMERA_SPEED
var camera_timer := 0.0
var lava_offset: float
var rope_location: Vector2
var dead: bool = false
var won: bool = false


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
		if child.name.begins_with("YouWon"):
			child.queue_free()
		if child.name.begins_with("Rope"):
			child.queue_free()
	rope = Rope.instantiate()
	add_child(rope, true)
	rope.global_position = rope_location
	song_gameplay.stop()
	song_gameplay_intro.play()
	song_gameplay.volume_db = 0.0
	dead = false
	won = false
	world_environment.environment.tonemap_exposure = 0.8


func win() -> void:
	var you_won = YouWon.instantiate()
	add_child(you_won)
	you_won.global_position = Vector2(477.0, -75.0)
	won = true


# Internal functions
func _ready() -> void:
	camera.make_current()
	if Configs.SPAWN_POINT == 1:
		rope_location = spawn_point_1.global_position
		camera_location = camera_point_1.global_position
	elif Configs.SPAWN_POINT == 2:
		rope_location = spawn_point_2.global_position
		camera_location = camera_point_2.global_position
	elif Configs.SPAWN_POINT == 3:
		rope_location = spawn_point_3.global_position
		camera_location = camera_point_3.global_position
	lava_offset = lava.global_position.y - camera.global_position.y
	camera.global_position = camera_location
	spawn_players()


func _process(delta: float) -> void:
	if camera_timer < Configs.CAMERA_DELAY:
		camera_timer += delta
	elif not won or camera.global_position.y > -70.0:
		camera_speed = camera_speed + Configs.CAMERA_ACCELERATION * delta
		camera.global_position.y -= camera_speed * delta
		lava.global_position.y = camera.global_position.y + lava_offset

	if won:
		world_environment.environment.tonemap_exposure = lerp(world_environment.environment.tonemap_exposure, 0.5, 0.005)

	# Bind ESC to close game
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	# Bind TAB to fake win
	if Input.is_action_just_pressed("ui_focus_next"):
		win()

	# If dead, fade out music in 2 secs
	if dead or won:
		song_gameplay.volume_db -= 10*delta
		if song_gameplay.volume_db < -79:
			song_gameplay.stop()


func _on_song_gameplay_intro_finished() -> void:
	song_gameplay.play()


func _on_win_area_body_entered(body: Node2D) -> void:
	if not won:
		win()
