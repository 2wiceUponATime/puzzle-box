extends Node2D

const MAX_SIZE = 1000

@onready var level_width: LineEdit = $Buttons/LevelWidth
@onready var level_height: LineEdit = $Buttons/LevelHeight

func _on_play_button_pressed() -> void:
	var width := int(level_width.text)
	var height := int(level_height.text)
	if min(width, height) <= 0 or max(width, height) > MAX_SIZE:
		return
	Global.level = Global.Level.new(Vector2i(width, height))
	get_tree().change_scene_to_file("res://scenes/main.tscn")
