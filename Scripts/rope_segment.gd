extends RigidBody2D
class_name RopeSegment

func _ready() -> void:
	# Set values from configs
	mass = Configs.ROPE_MASS
	inertia = Configs.ROPE_INERTIA
	linear_damp = Configs.ROPE_DAMP
