class_name PathSequenceCharacter
extends CharacterBody2D

signal path_started(path_index: int)
signal path_finished(path_index: int)
signal sequence_finished

@export_category("Path Movement")
@export var paths: Array[Path2D] = []
@export var walking_speed := 100.0
@export var arrival_distance := 3.0
@export var start_path_index := 0

@export_category("Player Trigger")
@export var player: CharacterBody2D
@export var path_trigger: Area2D

@export_category("Animation")
@export var animated_sprite: AnimatedSprite2D
@export var idle_before_animation: StringName = &"Idle1"
@export var idle_after_animation: StringName = &"Idle2"

var current_path_index := 0
var path_offset := 0.0

var is_walking := false
var has_started_sequence := false
var waiting_for_trigger := false
var sequence_has_finished := false


func _ready() -> void:
	current_path_index = clampi(
		start_path_index,
		0,
		maxi(paths.size() - 1, 0)
	)

	velocity = Vector2.ZERO

	if path_trigger != null:
		path_trigger.body_entered.connect(
			_on_path_trigger_body_entered
		)

	_set_path_trigger_enabled(true)
	_play_animation_if_exists(idle_before_animation)


func _physics_process(_delta: float) -> void:
	if not is_walking:
		velocity = Vector2.ZERO
		return

	var path := _get_current_path()

	if not _is_path_valid(path):
		_finish_current_path()
		return

	var curve_length := path.curve.get_baked_length()

	if curve_length <= 0.0:
		_finish_current_path()
		return

	var target_offset := minf(
		path_offset + maxf(arrival_distance, 1.0),
		curve_length
	)

	var target_local := path.curve.sample_baked(
		target_offset
	)

	var target_global := path.to_global(
		target_local
	)

	var direction := global_position.direction_to(
		target_global
	)

	velocity = direction * walking_speed
	move_and_slide()

	# Update progress using the character's actual position.
	var character_local_position := path.to_local(
		global_position
	)

	var closest_offset := path.curve.get_closest_offset(
		character_local_position
	)

	path_offset = maxf(
		path_offset,
		closest_offset
	)

	if velocity.length_squared() > 0.01:
		_update_animation(velocity)

	var end_local := path.curve.sample_baked(
		curve_length
	)

	var end_global := path.to_global(
		end_local
	)

	var reached_end_offset := (
		path_offset >= curve_length - arrival_distance
	)

	var reached_end_position := (
		global_position.distance_to(end_global)
		<= arrival_distance * 2.0
	)

	if reached_end_offset and reached_end_position:
		global_position = end_global
		_finish_current_path()


# Starts whichever path is currently selected.
func start_walking() -> void:
	if is_walking:
		return

	if sequence_has_finished:
		return

	if paths.is_empty():
		push_warning(
			"PathSequenceCharacter: no paths were assigned."
		)
		return

	var path := _get_current_path()

	if not _is_path_valid(path):
		push_warning(
			"PathSequenceCharacter: current Path2D is invalid."
		)
		return

	has_started_sequence = true
	waiting_for_trigger = false

	var character_local_position := path.to_local(
		global_position
	)

	path_offset = path.curve.get_closest_offset(
		character_local_position
	)

	is_walking = true

	# The player cannot activate another path while
	# the character is walking.
	_set_path_trigger_enabled(false)

	path_started.emit(current_path_index)


# Starts the next path after the current path has ended.
func advance_to_next_path() -> void:
	if is_walking:
		return

	if sequence_has_finished:
		return

	# The first trigger interaction starts paths[0].
	if not has_started_sequence:
		start_walking()
		return

	if not waiting_for_trigger:
		return

	# The character has completed every assigned path.
	if current_path_index + 1 >= paths.size():
		waiting_for_trigger = false
		sequence_has_finished = true

		_set_path_trigger_enabled(false)
		_play_animation_if_exists(idle_after_animation)

		sequence_finished.emit()
		return

	current_path_index += 1
	start_walking()


# Universal method called by the child trigger.
#
# First interaction:
# Starts paths[0].
#
# Later interactions:
# Starts the next path after the previous path ends.
func proceed() -> void:
	if not has_started_sequence:
		start_walking()
	else:
		advance_to_next_path()


func _finish_current_path() -> void:
	is_walking = false
	velocity = Vector2.ZERO
	waiting_for_trigger = true

	_play_animation_if_exists(idle_after_animation)

	# The trigger becomes active around the character
	# after they reach the end of the path.
	_set_path_trigger_enabled(true)

	path_finished.emit(current_path_index)


func _on_path_trigger_body_entered(
	body: Node2D
) -> void:
	if body != player:
		return

	if is_walking:
		return

	if sequence_has_finished:
		return

	proceed()


func _set_path_trigger_enabled(
	enabled: bool
) -> void:
	if path_trigger == null:
		return

	path_trigger.set_deferred(
		"monitoring",
		enabled
	)


func _get_current_path() -> Path2D:
	if current_path_index < 0:
		return null

	if current_path_index >= paths.size():
		return null

	return paths[current_path_index]


func _is_path_valid(path: Path2D) -> bool:
	if path == null:
		return false

	if path.curve == null:
		return false

	if path.curve.point_count == 0:
		return false

	return true


func _update_animation(
	movement: Vector2
) -> void:
	var directions: Array[StringName] = [
		&"Right",
		&"BottomRight",
		&"Bottom",
		&"BottomLeft",
		&"Left",
		&"TopLeft",
		&"Top",
		&"TopRight"
	]

	var angle := fposmod(
		movement.angle(),
		TAU
	)

	var slice_index := int(
		(angle + TAU / 16.0)
		/ (TAU / 8.0)
	) % 8

	var animation_name := directions[
		slice_index
	]

	_play_animation_if_exists(
		animation_name
	)


func _play_animation_if_exists(
	animation_name: StringName
) -> void:
	if animated_sprite == null:
		return

	if animated_sprite.sprite_frames == null:
		return

	if animated_sprite.sprite_frames.has_animation(
		animation_name
	):
		animated_sprite.play(
			animation_name
		)
