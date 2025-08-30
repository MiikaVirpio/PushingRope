extends RigidBody2D
class_name Player

# Constant parameters
enum STATES {IDLE,WALKING,JUMPING,HANGING}
# Export variables
@export var player_id := "p1"
# Onready variables
# Variables
var move_force := 10000.0
var jump_force := 5000.0
var player_state := STATES.IDLE

# Custom functions

# Internal functions
func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	# Apply horizontal force
	if Input.is_action_pressed(player_id + "left"):
		apply_central_force(Vector2(-move_force, 0))
	elif Input.is_action_pressed(player_id + "right"):
		apply_central_force(Vector2(move_force, 0))
	
	# Apply vertical force
	if Input.is_action_just_pressed(player_id + "jump") and player_state in [STATES.IDLE, STATES.WALKING]:
		apply_central_impulse(Vector2(0, -jump_force))
		player_state = STATES.JUMPING


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var horizontal_velocity = abs(linear_velocity.x)
	var vertical_velocity = abs(linear_velocity.y)
	
	if player_state == STATES.JUMPING and vertical_velocity < 10:
		if horizontal_velocity < 0.5:
			player_state = STATES.IDLE
		else:
			player_state = STATES.WALKING
	
	if player_state == STATES.WALKING and horizontal_velocity < 0.5:
		player_state = STATES.IDLE
