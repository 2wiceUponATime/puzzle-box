extends Node2D

const MIN_SWIPE_DISTANCE = 25
const MIN_SWIPE_SPEED = 900
const MAX_SWIPE_OFFSET = 0.3

@onready var player: Sprite2D = $Player

var swipe_pos: Vector2
var swipe_start: int

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		swipe_pos = get_local_mouse_position()
		swipe_start = Time.get_ticks_msec()
	if event.is_action_released("click"):
		var swipe := get_local_mouse_position() - swipe_pos
		var swipe_distance := swipe.length()
		var swipe_time := Time.get_ticks_msec() - swipe_start
		var swipe_speed := swipe_distance / swipe_time * 1000
		if swipe_distance < MIN_SWIPE_DISTANCE and swipe_speed < MIN_SWIPE_SPEED:
			return
		var angle := swipe.angle() / (PI/2)
		if abs(angle - round(angle)) > MAX_SWIPE_OFFSET:
			return
		player.move(Vector2.RIGHT.rotated(round(angle) * PI/2).round())
