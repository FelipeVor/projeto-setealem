extends CharacterBody2D

const SPEED = 100
var bodies: int:
	set(value):
		bodies = clamp(value, 0, 100)
var stress_regen: int
var stress: float:
	set(value):
		stress = clamp(value, 0.0, 100.0)
var anim := "front"


func _physics_process(_delta: float) -> void:
	$"../CanvasLayer/Label".text = str("stress: ", stress)
	
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
	
func mouse_follow():
	$PointLight2D.look_at(get_global_mouse_position())

func set_stress(damage):
	stress += damage

func player():
	pass

func stress_overtime():
	$"../CanvasLayer/bodies".text = str("bodies: ", bodies)
	if bodies >= 1:
		stress += 3 * float(bodies)/10
	else:
		stress -= 1
	print(stress)
	
#alucintaio

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		if body.discovered == false:
			bodies += 1

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		if body.discovered == false:
			bodies -= 1

func _on_light_area_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		$"../CanvasLayer/debugs".text = "to vendo bixo"
		if body.discovered == false:
			body.discovered = true
			bodies -= 1

func _on_light_area_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		$"../CanvasLayer/debugs".text = ""
