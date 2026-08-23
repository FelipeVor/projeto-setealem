extends Node2D

var fade_out := true
var fade_in := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/ColorRect.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if fade_out:
		if $CanvasLayer/ColorRect.color.a > 0:
			$CanvasLayer/ColorRect.color.a -= 0.02
	if fade_in:
		if $CanvasLayer/ColorRect.color.a < 1:
			$CanvasLayer/ColorRect.color.a += 0.02
		else: get_tree().change_scene_to_file("res://Scenes/interview.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		$Enemies/Player.cutscene = true
		fade_in = true
		fade_out = false
