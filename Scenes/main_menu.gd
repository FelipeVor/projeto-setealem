extends Node2D


var start = false

func _on_start_pressed() -> void:
	start = true


func _process(_delta: float) -> void:
	if start:
		if $ColorRect.color.a < 1:
			$ColorRect.color.a += 0.02
			$buttons.modulate.a -= 0.2
		else:
			get_tree().change_scene_to_file("res://Scenes/computer_scene.tscn")
