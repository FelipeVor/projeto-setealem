extends CharacterBody2D

@onready var player: CharacterBody2D = $"../Player"
@onready var navi: NavigationAgent2D = $NavigationAgent2D
@onready var die_screen: CanvasLayer = $"../../DieScreen"

var dist := 0

var detect := false
var come := false
var discovered := false

var die := false

var status := "walk-"
var timer_status := 0.0

var anim := "down"

func sac_man():
	pass

func status_change(delta):
	if detect:
		timer_status -= delta
		
		if timer_status > 0:
			status = "walk-"
			timer_status -= delta
		elif status != "attack-": status = "run-"
		

func _ready():
	randomize()
	timer_status = randf_range(2.0, 5.0)
	


func _physics_process(delta: float) -> void:
	
	status_change(delta)
	if die:
		if self.modulate.a > 0:
			self.modulate.a -= 0.02
		else:
			player.lantern = false
			player.cutscene = false
			queue_free()

	if status != "run-":
		dist = int(player.global_position.distance_to(global_position))
		dist = clamp(dist, 2, 1000)
		if dist < 180 or not detect:
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
	if not come:
		if status == "attack-" and $AnimatedSprite2D.frame >= 25:
			come = true
			$AnimatedSprite2D.stop()
			$AnimatedSprite2D.frame = 25
			player.cutscene = true
			if not player.lantern:
				if die_screen != null:
					die_screen.die = true
					get_tree().paused = true
			else:
				die = true
		else:
			$AnimatedSprite2D.play(status + anim)

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	var speed := 300
	if status != "run-":
		speed = lerp(0.0, 500.0, float(dist) / 1000.0)
	if die or not detect:
		speed = 0

	velocity = velocity.move_toward(
		safe_velocity.normalized() * speed,
		15.0
	)

	move_and_slide()

func _on_detect_player_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		detect = true
