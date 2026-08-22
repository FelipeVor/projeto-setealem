extends CharacterBody2D

const SPEED = 100

var direction: Vector2 = Vector2.ZERO
var direction_light: Vector2 = Vector2.ZERO

var bodies_hallu: int:
	set(value):
		bodies_hallu = clamp(value, 0, 100)
var bodies_enemy: int:
	set(value):
		bodies_enemy = clamp(value, 0, 100)

@onready var spawn_area: Area2D = $spawn_area

const ENEMY = preload("uid://dfpnwfaqaogiu")

var stress_regen: int
var stress: float:
	set(value):
		stress = clamp(value, 0.0, 100.0)
var anim := "front"

var target_body: Array
var rays: Array
var timers: Array

@export var other_world := false

var enemy_num := 0

var cutscene := false

func _ready() -> void:
	if other_world:
		$heart.playing = true
		$bg_other.playing = true
	else:
		$heart.playing = false
		$bg_other.playing = false

func _physics_process(delta: float) -> void:
	
	if other_world:
		$heart.pitch_scale = lerp(0.5, 4.0, stress/100)
		ray_to_body(target_body)
		ray_check(delta)
	else:
		$heart.playing = false
		$bg_other.playing = false
	
	mouse_follow()
	
	$"Timer-Enemy".wait_time = lerp(25.0, 5.0, stress/100)
	
	if not cutscene:
		direction = Input.get_vector("left", "right", "up", "down")
	
	if not cutscene:
		direction_light = Vector2(self.global_position - get_global_mouse_position()).normalized()
	
	if direction_light.y < 0  and direction_light.x == clamp(direction_light.x, -0.9, 0.9):
		$anim.flip_h = false
		anim = "walk_front"
	elif direction_light.y > 0 and direction_light.x == clamp(direction_light.x, -0.9, 0.9):
		$anim.flip_h = false
		anim = "walk_back"
	elif direction_light.x > 0:
		$anim.flip_h = true
		anim = "walk_side"
	elif direction_light.x < 0:
		$anim.flip_h = false
		anim = "walk_side"
		
	if direction != Vector2.ZERO: 
		$anim.play(anim)
	else:
		$anim.play(anim, 0)
		$anim.set_frame_and_progress(1, 1)
		
	velocity = direction * SPEED

	move_and_slide()

func ray_to_body(body_list: Array):
		for body in body_list:
			for ray in rays:
				ray.target_position = to_local(body.global_position)

func ray_check(delta: float):
	for body in target_body:
		var index = target_body.find(body)
		rays[index].force_raycast_update()
		timers[index] += delta
		print(timers[index])
		if timers[index] >= 0.45:
			if rays[index].is_colliding():
				print("ray do ", body.name, " colidiu com ", rays[index].get_collider().name)
			else:
				if body.has_method("hallu"):
					if body.discovered == false:
						body.discovered = true
						stress -= 5
						bodies_hallu -= 1
				if body.has_method("enemy"):
					if body.discovered == false:
						body.discovered = true
						bodies_enemy -= 1

func get_random_area() -> Vector2:
	var col_shape = spawn_area.get_node("CollisionShape2D")
	var radius: float = col_shape.shape.radius
	var min_radius: float = 200.0
	var angle = randf() * TAU
	var distance = sqrt(randf_range(min_radius * min_radius, radius * radius))
	
	var movement = Vector2(cos(angle), sin(angle)) * distance
	return col_shape.global_position + movement


func mouse_follow():
	$PointLight2D.look_at(get_global_mouse_position())

func player():
	pass

func stress_overtime():
	if bodies_hallu >= 1:
		stress += 5 * float(bodies_hallu)/10
	else:
		stress -= 0.2
	if bodies_enemy >= 1:
		stress += 8 * float(bodies_enemy)/10

func _on_area_2d_body_entered(body: Node2D) -> void:
		if body.has_method("hallu"):
			if body.discovered == false:
				bodies_hallu += 1
		if body.has_method("enemy"):
			if body.discovered == false:
				bodies_enemy += 1
				body.audio_play = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("hallu"):
		if body.discovered == false:
			bodies_hallu -= 1
	if body.has_method("enemy"):
		if body.discovered == false:
			bodies_enemy -= 1
			body.audio_play = false

func _on_light_area_body_entered(body: Node2D) -> void:
	target_body.append(body)
	var ray := RayCast2D.new()
	add_child(ray)
	rays.append(ray)
	var timer := 0
	timers.append(timer)

func _on_light_area_body_exited(body: Node2D) -> void:
	var index = target_body.find(body)
	target_body.erase(body)
	if index > -1:
		var ray = rays[index]
		ray.queue_free()
		rays.remove_at(index)
		timers.remove_at(index)

func take_stress_damage(damage) -> void:
	stress += damage


func _on_close_area_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		stress += 30
		body.discovered = true
		bodies_enemy -= 1


func _on_timer_enemy_timeout() -> void:
	if other_world:
		print("Timer disparou! Tentando spawnar... Inimigos atuais: ", enemy_num)
		if enemy_num <= 4:
			var ene = ENEMY.instantiate()
			get_parent().add_child(ene)
			ene.visible = false
			ene.position = get_random_area()
			enemy_num += 1
