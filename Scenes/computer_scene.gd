extends Node2D

var is_dialogue := true

var text1 : Array[String] = [
	"Olha esse Marcos.", 
	"Deixe de ser sem noção, tá querendo se aparecer? Vai pra
	um circo, palhaço.",
	"Seteaquém? Historinha de criança...",
	"Até parece que algo assim possa existir.", 
	"Normie cai em cada merda..."
]
var porta : Array[String] = [
	"TOC TOC TOC TOC "
]
var text2 : Array[String] = [
	"Filho, você não tem uma entrevista amanhã de manhã?", 
]
var text3 : Array[String] = [
	"Tô fazendo algo importante."
]
var text4 : Array[String] = [
	"Certo... Não fique até muito tarde na frente desse computador.",
	"Tá fazendo mal pra seus olhos."
]
var text5 : Array[String] = [
	"Você acredita em qualquer coisa...",
	"Isso é mentira desses programas de tv, mãe. E eu já vou dormir."
]
func _ready() -> void:
	$ColorRect.color.a = 1
	
func _process(_delta: float) -> void:
	if is_dialogue:
		if $ColorRect.color.a > 0:
			$ColorRect.color.a -= 0.03
		else:
			await get_tree().create_timer(1.5).timeout
			$SimpleDialogue.start_dialogue(text1 , "Arthur")
			await $SimpleDialogue.dialogue_finished
			$SimpleDialogue.start_dialogue(porta , "Event")
			await $SimpleDialogue.dialogue_finished
			$SimpleDialogue.start_dialogue(text2, "Mother")
			await $SimpleDialogue.dialogue_finished
			$SimpleDialogue.start_dialogue(text3, "Arthur")
			await $SimpleDialogue.dialogue_finished
			$SimpleDialogue.start_dialogue(text4, "Mother")
			await $SimpleDialogue.dialogue_finished
			$SimpleDialogue.start_dialogue(text5, "Arthur")
			await $SimpleDialogue.dialogue_finished
			is_dialogue = false
	else:
		if $ColorRect.color.a < 1:
			$ColorRect.color += Color(0,0,0,0.015)
		else:
			$Control/Label.modulate.a += 0.015
		if $Control/Label.modulate.a >= 1:
			get_tree().change_scene_to_file("res://Scenes/first_scene_kitchen.tscn")
