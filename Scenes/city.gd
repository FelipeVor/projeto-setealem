extends Node2D

var fade_out := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/ColorRect.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if fade_out:
		if $CanvasLayer/ColorRect.color.a > 0:
			$CanvasLayer/ColorRect.color.a -= 0.02
