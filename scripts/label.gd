extends Node2D

@onready var label: Label = $Label
@onready var is_ready = true

var text := "":
	set(value):
		if not is_ready:
			await ready
		text = value
		label.text = value
