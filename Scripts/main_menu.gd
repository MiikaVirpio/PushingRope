extends Control
class_name MainMenu

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _process(_delta: float) -> void:
	# Bind ESC to close game
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
