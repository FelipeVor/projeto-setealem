extends CharacterBody2D

const SPEED = 100
var anim := "front"

func _physics_process(_delta: float) -> void:
	
	mouse_follow()
	
	var direction := Input.get_vector("left", "right", "up", "down")
	
	var direction_light = Vector2($".".position - get_global_mouse_position()).normalized()
	
	$"../Label".text = str(direction_light)
	
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
