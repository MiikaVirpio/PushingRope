extends Path2D

@export var loop : bool
@export var speed : float
@export var speed_scale : float
@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer

func _ready() -> void:
	animation.play("move")
	animation.speed_scale = speed_scale
	set_process(false)
	
func _process(_delta) -> void:
	path.progress += speed
