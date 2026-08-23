extends Node2D

var fade_in := false
var fade_out := true
var cutscene_started := false

var text1 : Array[String] = [
	"José, certo?"
]
var text2 : Array[String] = [
	"Sim."
]
var text3 : Array[String] = [
	"Devemos começar?"
]
var text4 : Array[String] = [
	"Sim."
]
var text5 : Array[String] = [
	"Tá se sentindo tímido?",
	"Pode ficar tranquilo, vai ser bem leve.",
	"Aqui aponta que sua última experiência de trabalho foi há 4 anos atrás,",
	"você pode me explicar?"
]
var text6 : Array[String] = [
	"Foi um período difícil, mas estou tentando me recuperar."
]
var text7 : Array[String] = [
	"Certo, e o que você espera desse cargo?"
]
var text8 : Array[String] = [
	"É...",
	"...",
	"... Sei lá, acho que ficar na parte das entrevistas né..."
]
var text9 : Array[String] = [
	"Certo, quais você acha que são nossas responsabilidades como empresa e
	como você deve mantê-las com os funcionários?"
]
var text10 : Array[String] = [
	"Acho que... devo verificar os pagamentos e falar com eles."
]
var text11 : Array[String] = [
	"É...",
	"... Okay",
	"E a sua disponibilidade para nosso programa de treinamento?"
]
var text12 : Array[String] = [
	"Pode ser apenas durante a tarde?",
	"Sou... ocupado durante a manhã."
]
var text13 : Array[String] = [
	"Estarei encerrando sua estrevista por aqui.",
	"Fique de olho no seu sms, entraremos em contato."
]
var text14 : Array[String] = [
	"Okay..."
]

var text15 : Array[String] = [
	"Tenha um bom dia, josé."
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.cutscene = true
	$Player/Camera2D.set_as_top_level(true)
	$Player/Camera2D.global_position = Vector2(240, 135)
	$SimpleDialogue/CanvasLayer/ColorRect.color.a = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fade_out:
		if $SimpleDialogue/CanvasLayer/ColorRect.color.a > 0:
			$SimpleDialogue/CanvasLayer/ColorRect.color.a -= 0.02
	if fade_in:
		if $SimpleDialogue/CanvasLayer/ColorRect.color.a < 1:
			$SimpleDialogue/CanvasLayer/ColorRect.color.a += 0.02
	if $SimpleDialogue/CanvasLayer/ColorRect.color.a <= 0:
		if not cutscene_started:
				cutscene_started = true 
				next_part(delta)

func next_part(delta):
	$Player.direction = Vector2(1,0)
	$Player.direction_light = Vector2(-1,0)
	await get_tree().create_timer(delta * 152).timeout
	$Player.direction = Vector2.ZERO
	$Player.direction_light = Vector2(0,1)
	await get_tree().create_timer(0.01).timeout
	$SimpleDialogue.start_dialogue(text1, "Interview")
	await $SimpleDialogue.dialogue_finished
	$SimpleDialogue.start_dialogue(text2, "Arthur")
	await $SimpleDialogue.dialogue_finished
	$SimpleDialogue.start_dialogue(text3, "Interview")
	await $SimpleDialogue.dialogue_finished
	$SimpleDialogue.start_dialogue(text4, "Arthur")
	await $SimpleDialogue.dialogue_finished
	$SimpleDialogue.start_dialogue(text5, "Interview")
	await $SimpleDialogue.dialogue_finished
	$SimpleDialogue.start_dialogue(text6, "Arthur")
	await $SimpleDialogue.dialogue_finished
	$SimpleDialogue.start_dialogue(text7, "Interview")
	await $SimpleDialogue.dialogue_finished
	$SimpleDialogue.start_dialogue(text8, "Arthur")
	await $SimpleDialogue.dialogue_finished
	$SimpleDialogue.start_dialogue(text9, "Interview")
	await $SimpleDialogue.dialogue_finished
	$SimpleDialogue.start_dialogue(text10, "Arthur")
	await $SimpleDialogue.dialogue_finished
	$SimpleDialogue.start_dialogue(text11, "Interview")
	await $SimpleDialogue.dialogue_finished
	$SimpleDialogue.start_dialogue(text12, "Arthur")
	await $SimpleDialogue.dialogue_finished
	$SimpleDialogue.start_dialogue(text13, "Interview")
	await $SimpleDialogue.dialogue_finished
	$SimpleDialogue.start_dialogue(text14, "Arthur")
	await $SimpleDialogue.dialogue_finished
	$SimpleDialogue.start_dialogue(text15, "Interview")
	$Player.direction = Vector2(-1,0)
	$Player.direction_light = Vector2(1,0)
	await get_tree().create_timer(2.8).timeout
	get_tree().change_scene_to_file("res://Scenes/city2.tscn")
