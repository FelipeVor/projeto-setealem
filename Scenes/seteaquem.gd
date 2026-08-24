extends Node2D

var text1: Array[String] = [
	"ONDE EU TÔ!???"
]
var text2: Array[String] = [
	"Senhor, você sabe que horas passa o ônibus?"
]
var text3: Array[String] = [
	"... O-o que?"
]
var text4: Array[String] = [
	"O ônibus, o que vem pra seteaquém.",
	"Eu e minha irmã estamos esperando nossa mãe, ela devia chegar 
	aqui às 5:00."
]
var text5: Array[String] = [
	"E-eu não sei nem que lugar é esse."
]
var text6: Array[String] = [
	"Você não é daqui?",
	"Tudo bem senhor, é que tá chegando a hora...", 
	"Minha irmã não pode ficar na rua. Se eu tivesse uma lanterna, 
	já estaríamos em casa."
]
var text7: Array[String] = [
	"Hora? que hora?",
]
var text8: Array[String] = [
	"A hora que eles vem nos pegar. Você ainda não os ouviu?",
]
var text9: Array[String] = [
	"Eles? Quem são eles? Eu não ouço nada..."
]
var text10: Array[String] = [
	"Não ouve nada?",
	"Minha mãe diz que devemos sempre enxergar com os ouvidos 
	e ouvir com os olhos.",
	"No fim eu só miro a luz em direção ao barulho"
]
var text10_2: Array[String] = [
	"Irmã, eu tô com medo.",
	"Sinto que estão me olhando de todos os lados.",
    "Ilumina aqui... por favor."
]
var text11: Array[String] = [
	"...",
	"Que lugar é esse..."
]

func _ready() -> void:
	$Enemies/Player.cutscene = true
	$Enemies/Player.direction = Vector2(-1,0)
	$Enemies/Player.direction_light = Vector2(1,0)
	await get_tree().create_timer(0.5).timeout
	#$Enemies/Player.direction = Vector2.ZERO
	#await get_tree().create_timer(1).timeout
	#$Enemies/Player.direction_light = Vector2(-1,0)
	#await get_tree().create_timer(1).timeout
	#$Enemies/Player.direction = Vector2.ZERO
	#$Enemies/Player.direction_light = Vector2(1,0)
	#await get_tree().create_timer(1).timeout
	#$Enemies/Player.direction = Vector2.ZERO
	#$Enemies/Player.direction_light = Vector2(0,-1)
	#await get_tree().create_timer(0.5).timeout
	#$SimpleDialogue.start_dialogue(text1, "Arthur")
	#await $SimpleDialogue.dialogue_finished
	#$SimpleDialogue.start_dialogue(text2, "Mother")
	#await $SimpleDialogue.dialogue_finished
	#$Enemies/Player.direction_light = Vector2(0,1)
	#await get_tree().create_timer(0.01).timeout
	#$SimpleDialogue.start_dialogue(text3, "Arthur")
	#await $SimpleDialogue.dialogue_finished
	#$SimpleDialogue.start_dialogue(text4, "Mother")
	#await $SimpleDialogue.dialogue_finished
	#$SimpleDialogue.start_dialogue(text5, "Arthur")
	#await $SimpleDialogue.dialogue_finished
	#$SimpleDialogue.start_dialogue(text6, "Mother")
	#await $SimpleDialogue.dialogue_finished
	#$SimpleDialogue.start_dialogue(text7, "Arthur")
	#await $SimpleDialogue.dialogue_finished
	#$SimpleDialogue.start_dialogue(text8, "Mother")
	#await $SimpleDialogue.dialogue_finished
	#$SimpleDialogue.start_dialogue(text9, "Arthur")
	#await $SimpleDialogue.dialogue_finished
	#$SimpleDialogue.start_dialogue(text10, "Mother")
	#await $SimpleDialogue.dialogue_finished
	#$SimpleDialogue.start_dialogue(text10_2, "Mother")
	#await $SimpleDialogue.dialogue_finished
	#$SimpleDialogue.start_dialogue(text11, "Arthur")
	#await $SimpleDialogue.dialogue_finished
	$Enemies/Player.cutscene = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass












func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		$Enemies/Player.enimies_spawn = false
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		$Enemies/Player.enimies_spawn = true
