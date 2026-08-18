extends CharacterBody2D

var discovered := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Hallucinations")

func hallu():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if discovered:
		pass
