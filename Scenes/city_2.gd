extends Node2D

var text1 : Array[String] = [
	"Eu estraguei tudo...",
	"Argh, cansei... vou pra casa."
]

var text2 : Array[String] = [
	"Não passe por aqui não viu, esse caminho dá no seteaquém.",
]

var text3 : Array[String] = [
	"Cala a boca velho, seu bafo tá podre",
	'"Seteaquém" haha',
]

var enter := false
var next := false

func _process(_delta: float) -> void:
	if $CanvasLayer/ColorRect.color.a > 0:
		$CanvasLayer/ColorRect.visible = true
		$CanvasLayer/ColorRect.color.a -= 0.02
		$Enemies/Player.cutscene = true
	else:
		$Enemies/Player.cutscene = false
		if not next:
			$SimpleDialogue.start_dialogue(text1 , "Arthur")
			await $SimpleDialogue.dialogue_finished
			next = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		if not enter:
			$Enemies/Player.direction = Vector2.ZERO
			$Enemies/Player.direction_light = Vector2(0,1)
			$Enemies/Player.cutscene = true
			await get_tree().create_timer(0.1).timeout
			$SimpleDialogue.start_dialogue(text2 , "Old")
			await $SimpleDialogue.dialogue_finished
			$SimpleDialogue.start_dialogue(text3 , "Arthur")
			await $SimpleDialogue.dialogue_finished
			enter = true
			$Enemies/Player.cutscene = false


func _on_sete_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		await get_tree().physics_frame
		get_tree().change_scene_to_file("res://Scenes/seteaquem.scn")
