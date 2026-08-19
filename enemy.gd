extends CharacterBody2D

var move_speed:= 210

@onready var player: CharacterBody2D = $"../Player"
@onready var navi: NavigationAgent2D = $NavigationAgent2D

var audio_play := false

var discovered := false

func enemy():
	pass

func _physics_process(_delta: float) -> void:
	
	audio()
	was_discovered()
	
	#follow player
	var current_pos := self.global_transform.origin
	var next_pos := navi.get_next_path_position()
	var new_velocity = current_pos.direction_to(next_pos)
	navi.velocity = new_velocity
	navi.target_position = player.global_transform.origin
	#----

func audio():
	if audio_play:
		$alert.play()
		audio_play = false
	else:
		print("olá")
		if not $alert.playing:
			$alert.stop()
			
func was_discovered():
	if discovered:
		move_speed = 100

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = velocity.move_toward(safe_velocity * move_speed, 15)
	move_and_slide()

func _on_detect_player_body_exited(body: Node2D) -> void:
	if body.has_method("player"): queue_free()
