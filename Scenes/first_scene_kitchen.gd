extends Node2D

var wake := false
var cutscene_started := false
var fade_in := false

var text1 :Array[String] = [
	"TOC TOC TOC TOC"
]
var text2 :Array[String] = [
	"Arthur, meu filho, acorda!"
]
var text3 :Array[String] = [
	"Já vou mãe."
]
var text4 :Array[String] = [
	"Tem bolo de laranja pra você, filho. Comprei as laranjas com a Fátima, 
	cedinho.",
	"Não vai comer?"
]
var text5: Array[String] = [
	"Não vai dar tempo, mãe. E você já deveria saber que não gosto de comer
	pela manhã"
]
var text6: Array[String] = [
	"Espera filho. Você sabe como as coisas tão difíceis, né?"
]
var text7: Array[String] = [
	"Fala logo, mãe."
]
var text8: Array[String] = [
	"Por favor, não desiste da entrevista, a sua mãe precisa de uma ajudinha
	 com as contas."
]
var text9: Array[String] = [
	"Eu já não te ajudo o suficiente?",
	"Você tá todo tempo me pedindo pra arrumar a casa, varrer o chão e sei lá
	o que mais.",
]
var text10: Array[String] = [
	"Só me deixa, eu preciso ir logo."
]

func _ready() -> void:
	$Player/Camera2D.set_as_top_level(true)
	$Player/Camera2D.global_position = Vector2(240, 135)
	$SimpleDialogue/CanvasLayer/ColorRect.color.a = 1
	
	# Inicia a sequência principal
	rodar_cutscene_inicial()

# Toda a lógica de tempo e diálogos concentrada em um lugar seguro
func rodar_cutscene_inicial() -> void:
	await get_tree().create_timer(1).timeout
	$SimpleDialogue.visible = true
	
	$SimpleDialogue.start_dialogue(text1, "Event")
	await $SimpleDialogue.dialogue_finished
	
	$SimpleDialogue.start_dialogue(text2, "Mother")
	await $SimpleDialogue.dialogue_finished
	
	$SimpleDialogue.start_dialogue(text3, "Arthur")
	await $SimpleDialogue.dialogue_finished
	
	wake = true 

func _process(_delta: float) -> void:
	if fade_in:
		if $SimpleDialogue/CanvasLayer/ColorRect.color.a < 1:
			$SimpleDialogue/CanvasLayer/ColorRect.color.a += 0.02
	elif wake:
		if $SimpleDialogue/CanvasLayer/ColorRect.color.a > 0:
			$SimpleDialogue/CanvasLayer/ColorRect.color.a -= 0.02
		else:
			if not cutscene_started:
				cutscene_started = true 
				second_part()

func second_part() -> void:
	$Player.collision_layer = 0
	$Player.collision_mask = 0
	$Player.cutscene = true
	$Player.direction = Vector2(1,0)
	$Player.direction_light = Vector2(-1,0)
	
	await get_tree().create_timer(1.5).timeout
	$SimpleDialogue.start_dialogue(text4, "Mother")
	await get_tree().create_timer(0.5).timeout
	$Player.direction = Vector2.ZERO
	await get_tree().create_timer(0.5).timeout
	
	$SimpleDialogue.start_dialogue(text4, "Mother")
	await $SimpleDialogue.dialogue_finished
	$Player.direction_light = Vector2(0,1)
	$Player.direction = Vector2(0,-1)
	$Player.direction = Vector2.ZERO
	await get_tree().create_timer(0.01).timeout
	$SimpleDialogue.start_dialogue(text5, "Arthur")
	await $SimpleDialogue.dialogue_finished
	
	$Player.direction = Vector2(1,0)
	$Player.direction_light = Vector2(-1,0)
	
	await get_tree().create_timer(1.5).timeout
	$SimpleDialogue.start_dialogue(text6, "Mother")
	await get_tree().create_timer(0.5).timeout
	$Player.direction = Vector2.ZERO
	await get_tree().create_timer(0.5).timeout
	
	$SimpleDialogue.start_dialogue(text6, "Mother")
	await $SimpleDialogue.dialogue_finished
	$Player.direction_light = Vector2(1,0)
	$Player.direction = Vector2(-1,0)
	$Player.direction = Vector2.ZERO
	await get_tree().create_timer(0.01).timeout
	$SimpleDialogue.start_dialogue(text7, "Arthur")
	await $SimpleDialogue.dialogue_finished
	$SimpleDialogue.start_dialogue(text8, "Mother")
	await $SimpleDialogue.dialogue_finished
	$SimpleDialogue.start_dialogue(text9, "Arthur")
	await $SimpleDialogue.dialogue_finished
	$Player.direction_light = Vector2(-1,0)
	$Player.direction = Vector2(1,0)
	$Player.direction = Vector2.ZERO
	await get_tree().create_timer(0.01).timeout
	$SimpleDialogue.start_dialogue(text10, "Arthur")
	await $SimpleDialogue.dialogue_finished
	$Player.direction_light = Vector2(-1,0)
	$Player.direction = Vector2(1,0)
	fade_in = true
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/city.tscn")
