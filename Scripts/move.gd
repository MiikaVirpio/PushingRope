extends Path2D

@export var loop : bool
@export var speed = 10
@export var speed_scale = 2
@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer

func _ready() -> void:
	animation.play("move")
	animation.speed_scale = speed_scale
	set_process(false)
	
func _process(_delta) -> void:
	path.progress += speed
