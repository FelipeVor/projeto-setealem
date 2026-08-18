extends CharacterBody2D

@export var damage := 20
@onready var timer: Timer = $Attack_timer
var discovered := false
var target: Node2D = null
signal stress_damage


func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_stress_damage"):
		target = body
		body.take_stress_damage(damage)
		timer.start(3)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		timer.stop()

func _on_attack_timer_timeout() -> void:
	target.take_stress_damage(damage)
