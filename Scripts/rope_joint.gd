extends PinJoint2D
class_name RopeJoint

func _ready() -> void:
	# Set values from configs
	softness = Configs.ROPE_SOFTNESS
	bias = Configs.ROPE_BIAS
