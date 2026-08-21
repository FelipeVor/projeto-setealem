extends CharacterBody2D

const SPEED = 100

var bodies_hallu: int:
	set(value):
		bodies_hallu = clamp(value, 0, 100)
var bodies_enemy: int:
	set(value):
		bodies_enemy = clamp(value, 0, 100)


var stress_regen: int
var stress: float:
	set(value):
		stress = clamp(value, 0.0, 100.0)
var anim := "front"

var target_body: Array
var rays: Array


func _physics_process(_delta: float) -> void:
	$"../CanvasLayer/Label".text = str("stress: ", stress)
	
	ray_to_body(target_body)
	
	ray_check()
	
	mouse_follow()
	
	var direction := Input.get_vector("left", "right", "up", "down")
	
	var direction_light = Vector2($".".position - get_global_mouse_position()).normalized()
	
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
	if body_list != []:
		#print("bodies:", target_body)
		#print("rays", rays)
		for body in body_list:
			for ray in rays:
				ray.target_position = to_local(body.position)
				#print("ray_pos:", ray.target_position)
				
func ray_check():
	for body in target_body:
		var index = target_body.find(body)
		rays[index].force_raycast_update()
		if rays[index].is_colliding():
			print("ray do ", body.name, " colidiu com ", rays[index].get_collider().name)
			$"../CanvasLayer/debugs".text = ""
		else:
			if body.has_method("hallu"):
				$"../CanvasLayer/debugs".text = "to vendo bixo"
				if body.discovered == false:
					body.discovered = true
					stress -= 5
					bodies_hallu -= 1
			if body.has_method("enemy"):
				$"../CanvasLayer/debugs".text = "to vendo bixo que mata"
				if body.discovered == false:
					body.discovered = true
					bodies_enemy -= 1


func mouse_follow():
	$PointLight2D.look_at(get_global_mouse_position())

func player():
	pass

func stress_overtime():
	$"../CanvasLayer/bodies".text = str("bodies: ", bodies_hallu)
	if bodies_hallu >= 1:
		stress += 8 * float(bodies_hallu)/10
	else:
		stress -= 0.2
	if bodies_enemy >= 1:
		stress += 15 * float(bodies_enemy)/10

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

func _on_light_area_body_exited(body: Node2D) -> void:
	var index = target_body.find(body)
	target_body.erase(body)
	if index > -1:
		var ray = rays[index]
		ray.queue_free()
		rays.remove_at(index)
	$"../CanvasLayer/debugs".text = ""

func take_stress_damage(damage) -> void:
	stress += damage
