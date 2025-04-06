extends Sprite2D

const LABEL = preload("res://scenes/label.tscn")

@onready var level: TileMapLayer = $"../Level"
@onready var move_sound: AudioStreamPlayer = $MoveSound
@onready var undo_sound: AudioStreamPlayer = $UndoSound
@onready var win_sound: AudioStreamPlayer = $WinSound
@onready var music: AudioStreamPlayer = $Music

var level_pos: Vector2i
var moving := false
var moves: Array[Vector2i] = []

func _input(event: InputEvent) -> void:
	if moving:
		return
	if event.is_action_pressed("left"):
		move(Vector2i.LEFT)
	elif event.is_action_pressed("right"):
		move(Vector2i.RIGHT)
	elif event.is_action_pressed("up"):
		move(Vector2i.UP)
	elif event.is_action_pressed("down"):
		move(Vector2i.DOWN)

func move(direction: Vector2i) -> void:
	moving = true
	var old_pos := level_pos
	var length: int = round(direction.length())
	var distance := 0
	while is_air(level_pos):
		level_pos += direction
		distance += length
		if distance > 1000:
			level_pos = old_pos
			return
	level_pos -= direction
	if level_pos == old_pos:
		moving = false
		return
	var new_pos := level_to_parent(level_pos)
	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", new_pos, 0.1)
	move_sound.play()
	await tween.finished
	moves.push_back(direction)
	Global.tile_block.set_cell(level, old_pos)
	var label := LABEL.instantiate()
	label.name = str(len(moves))
	label.text = str(len(moves))
	get_parent().add_child(label)
	label.position = level_to_parent(old_pos)
	moving = false
	if len(moves) >= level.air_tiles - 1:
		ToastParty.show({
			"text": "Level complete!",
			"bgcolor": Color(0, 0, 0, 0.7),
			"color": Color(1, 1, 1, 1),
			"gravity": "top",
			"direction": "center",
			"text_size": 8
		})
		moving = true
		music.stream_paused = true
		win_sound.play()
		await win_sound.finished
		moving = false
		music.stream_paused = false

func undo() -> void:
	if moving:
		return
	var direction = moves.pop_back()
	if not direction:
		return
	while is_air(level_pos):
		level_pos -= direction
	position = level_to_parent(level_pos)
	Global.tile_air.set_cell(level, level_pos)
	get_parent().get_node(str(len(moves) + 1)).queue_free()
	undo_sound.play()

func exit() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func level_to_parent(coords: Vector2i) -> Vector2:
	return get_parent().to_local(level.to_global(level.map_to_local(coords)))

func is_air(coords: Vector2i) -> bool:
	return level.get_cell_source_id(coords) == -1
