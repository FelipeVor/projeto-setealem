extends CanvasLayer

var die := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if die:
		if $ColorRect.modulate.a < 1:
			$ColorRect.modulate.a += delta
