extends CanvasLayer


@onready var dialogue_box: Control = $DialogueBox
@onready var text: Label = $DialogueBox/Text

var line_text : Array[String] = []
var current_line: int = 0
var is_dialogue_active : bool = false

var can_advance := true
signal dialogue_finished 

func _ready() -> void:
	self.visible = true
	dialogue_box.visible = false

func start_dialogue(lines: Array[String], face : String) -> void:
	# Pause the game when dialogue starts
	get_tree().paused = true
	$DialogueBox/Icon/HBoxContainer/Face.texture = load("res://Faces/" + face + ".png")
	line_text = lines
	current_line = 0
	is_dialogue_active = true
	dialogue_box.visible = true
	text.text = line_text[current_line]
	wait_next()

func _input(event: InputEvent) -> void:
	if not is_dialogue_active:
		return
	if can_advance:
		if event.is_action_pressed("mouse_click") or event.is_action_pressed("ui_accept"):
			wait_next()
			advance_dialogue()

func advance_dialogue() -> void:
	if current_line < line_text.size() - 1:
		current_line += 1
		text.text = line_text[current_line]
	else:
		get_tree().paused = false  # Resume the game when dialogue ends
		is_dialogue_active = false
		dialogue_box.visible = false
		dialogue_finished.emit() 
		
func wait_next() -> void:
	can_advance = false 
	await get_tree().create_timer(0.5).timeout 
	can_advance = true 
