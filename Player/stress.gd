class_name Stress extends Node

enum stress_state {LEVEL0, LEVEL1, LEVEL2, LEVEL3}

var current_level: stress_state = stress_state.LEVEL0

func stress_level():
	if $player.stress >= 70:
		current_level = stress_state.LEVEL3
	elif $player.stress >= 50:
		current_level = stress_state.LEVEL2
	elif $player.stress >= 20:
		current_level = stress_state.LEVEL1
	else:
		current_level = stress_state.LEVEL0;
			

func stress_effect():
	match current_level:
		0: pass
		1: pass
		2: pass
		3: pass
		
func panic_timer():
	pass
