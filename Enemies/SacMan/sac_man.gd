extends CharacterBody2D

@onready var player: CharacterBody2D = $"../Player"
@onready var navi: NavigationAgent2D = $NavigationAgent2D
@onready var die_screen: CanvasLayer = $"../../DieScreen"

var dist := 0

var discovered := false

var die := false

var status := "walk-"
var timer_status := 0.0

var anim := "down"

func sac_man():
	pass

func status_change(delta):
	timer_status -= delta
	
	if timer_status > 0:
		status = "walk-"
		timer_status -= delta
	elif status != "attack-": status = "run-"
		

func _ready():
	randomize()
	timer_status = randf_range(10.0, 15.0)
	


func _physics_process(delta: float) -> void:
	#was_discovered()
	status_change(delta)
	if die:
		if self.modulate.a > 0:
			self.modulate.a -= 0.02
		else:
			player.enemy_num -= 1
			queue_free()
	if status == "attack-" and $AnimatedSprite2D.frame == 30:
		if die_screen != null:
			die_screen.die = true
			get_tree().paused = true

	if status != "run-":
		dist = int(player.global_position.distance_to(global_position))
		dist = clamp(dist, 2, 1000)
		if dist < 180:
			dist = 0
	else:
		if die:
			dist = 0
		else:
			dist = 1000

	var current_pos := global_position
	var next_pos := navi.get_next_path_position()
	var new_velocity := current_pos.direction_to(next_pos)

	var speed = lerp(0.0, 50.0, float(dist) / 1000.0)

	navi.velocity = new_velocity * speed
	navi.target_position = player.global_position

	if new_velocity.x > 0.5 and abs(new_velocity.y) < 0.5:
		anim = "right"
	elif new_velocity.x < -0.5 and abs(new_velocity.y) < 0.5:
		anim = "left"
	elif abs(new_velocity.x) < 0.5 and new_velocity.y > 0.5:
		anim = "down"
	elif abs(new_velocity.x) < 0.5 and new_velocity.y < -0.5:
		anim = "up"
	elif new_velocity.x > 0.5 and new_velocity.y < -0.5:
		anim = "upRight"
	elif new_velocity.x > 0.5 and new_velocity.y > 0.5:
		anim = "downRight"
	elif new_velocity.x < -0.5 and new_velocity.y > 0.5:
		anim = "downLeft"
	elif new_velocity.x < -0.5 and new_velocity.y < -0.5:
		anim = "upLeft"
		
	print(status)
	$AnimatedSprite2D.play(status + anim)
	

#func was_discovered():
	#if discovered:
		#audio_play = false
		#self.visible = true
		#$detect_player.scale = Vector2(0.5,0.5)


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	var speed := 300
	if status != "run-":
		speed = lerp(0.0, 500.0, float(dist) / 1000.0)
	if die:
		speed = 0

	velocity = velocity.move_toward(
		safe_velocity.normalized() * speed,
		15.0
	)

	move_and_slide()

#func _on_detect_player_body_exited(body: Node2D) -> void:
	#if body.has_method("player"):
		#die = true
