extends CharacterBody2D

@onready var player: CharacterBody2D = $"../Player"
@onready var navi: NavigationAgent2D = $NavigationAgent2D

var dist := 0

var audio_play := false
var step := false

var discovered := false

func enemy():
	pass

func _physics_process(_delta: float) -> void:
	audio()
	was_discovered()

	if not discovered:
		self.visible = true

		dist = int(player.global_position.distance_to(global_position))
		dist = clamp(dist, 2, 1000)

	var current_pos := global_position
	var next_pos := navi.get_next_path_position()
	var new_velocity := current_pos.direction_to(next_pos)

	var speed = lerp(5.0, 50.0, float(dist) / 1000.0)

	navi.velocity = new_velocity * speed
	navi.target_position = player.global_position

	if new_velocity.x > 0.5 and abs(new_velocity.y) < 0.5:
		$AnimatedSprite2D.play("right")
	elif new_velocity.x < -0.5 and abs(new_velocity.y) < 0.5:
		$AnimatedSprite2D.play("left")
	elif abs(new_velocity.x) < 0.5 and new_velocity.y > 0.5:
		$AnimatedSprite2D.play("bottom")
	elif abs(new_velocity.x) < 0.5 and new_velocity.y < -0.5:
		$AnimatedSprite2D.play("top")
	elif new_velocity.x > 0.5 and new_velocity.y < -0.5:
		$AnimatedSprite2D.play("top-right")
	elif new_velocity.x > 0.5 and new_velocity.y > 0.5:
		$AnimatedSprite2D.play("bottom-right")
	elif new_velocity.x < -0.5 and new_velocity.y > 0.5:
		$AnimatedSprite2D.play("bottom-left")
	elif new_velocity.x < -0.5 and new_velocity.y < -0.5:
		$AnimatedSprite2D.play("top-left")


func audio():
	if not discovered:
		if not step:
			if audio_play:
				$alert.play()
				step = true
		else:
			if not $footstep.playing:
				$footstep.play()


func was_discovered():
	if discovered:
		audio_play = false
		self.visible = true
		$footstep.volume_db = 0


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	var speed := 40
	if not discovered:
		speed = lerp(1.0, 500.0, float(dist) / 1000.0)

	velocity = velocity.move_toward(
		safe_velocity.normalized() * speed,
		15.0
	)

	move_and_slide()

func _on_detect_player_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player.enemy_num -= 1
		queue_free()
