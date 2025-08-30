extends RigidBody2D
class_name Player

# Constant parameters
enum STATES {IDLE,WALKING,JUMPING,HANGING}
# Export variables
@export var player_id := "p1"
# Onready variables
# Variables
var move_force := Configs.MOVE_FORCE
var jump_force := Configs.JUMP_FORCE
var player_state := STATES.IDLE
@onready var animated_sprite = $Animation

# Custom functions

# Internal functions
func _ready() -> void:
	# Set values from configs
	mass = Configs.PLAYER_MASS
	physics_material_override.friction = Configs.PLAYER_FRICTION
	linear_damp = Configs.PLAYER_DAMP


func _physics_process(_delta: float) -> void:
	# Apply horizontal force
	if Input.is_action_pressed(player_id + "left"):
		apply_central_force(Vector2(-move_force, 0))
	elif Input.is_action_pressed(player_id + "right"):
		apply_central_force(Vector2(move_force, 0))
	
	# Apply vertical force
	if Input.is_action_just_pressed(player_id + "jump") and player_state in [STATES.IDLE, STATES.WALKING]:
		apply_central_impulse(Vector2(0, -jump_force))
		player_state = STATES.JUMPING
		animated_sprite.play("Jump")


func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	var horizontal_velocity = abs(linear_velocity.x)
	var vertical_velocity = abs(linear_velocity.y)
	
	if player_state == STATES.JUMPING and vertical_velocity < Configs.V_VELO_LIMIT:
		if horizontal_velocity < Configs.H_VELO_LIMIT:
			player_state = STATES.IDLE
			animated_sprite.play("Idle")
		else:
			player_state = STATES.WALKING
			animated_sprite.play("Walk")

	if player_state == STATES.WALKING and horizontal_velocity < Configs.H_VELO_LIMIT:
		player_state = STATES.IDLE
		animated_sprite.play("Idle")
	if player_state == STATES.IDLE and horizontal_velocity > Configs.H_VELO_LIMIT:
		player_state = STATES.WALKING
		animated_sprite.play("Walk")


func _process(_delta: float) -> void:
	if player_state == STATES.WALKING:
		animated_sprite.flip_h = sign(linear_velocity.x) < 0




func _on_body_entered(body: Node) -> void:
	# You touch lava, you die
	if body.name == "LavaTileMap":
		var death_position = global_position
		queue_free()
		get_tree().root.get_node("World").death(death_position)
