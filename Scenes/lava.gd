extends Node2D

var lava_offset := 1.0

@onready var lava_tile_map: TileMapLayer = $LavaTileMap

func _process(delta: float) -> void:
	# Animate lava up and down using the current time in milliseconds
	lava_tile_map.translate(Vector2(0, sin(Time.get_ticks_msec() / 500.0) * lava_offset*delta))    
