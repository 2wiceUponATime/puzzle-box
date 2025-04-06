extends Node

enum TileType {
	AIR,
	WALL,
	BLOCK,
}

var tile_air := Tile.new(-1, Vector2i(-1, -1))
var tile_wall := Tile.new(0, Vector2i(0, 1))
var tile_block := Tile.new(0, Vector2i(0, 0))

var tiles := {
	TileType.AIR: tile_air,
	TileType.WALL: tile_wall,
	TileType.BLOCK: tile_block,
}

var level: Level

class Level:
	var size: Vector2i
	var player_pos: Vector2i
	var tiles := {}
	func _init(level_size: Vector2i, player := Vector2i.ZERO) -> void:
		size = level_size
		player_pos = player

class Tile:
	var source_id: int
	var atlas_coords: Vector2i
	func _init(id, coords):
		source_id = id
		atlas_coords = coords
	func set_cell(map: TileMapLayer, pos: Vector2i):
		map.set_cell(pos, source_id, atlas_coords)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("screenshot") and OS.is_debug_build():
		var image = get_viewport().get_texture().get_image()
		var path = "user://screenshot.png"
		image.save_png(path)
		print("Screenshot saved as " + ProjectSettings.globalize_path(path))
		return

func get_tile(type: TileType) -> Tile:
	return tiles[type]

func scale_window(amount) -> void:
	var window := get_window()
	window.position -= window.size * (amount - 1) / 2
	window.size *= amount

func _ready() -> void:
	if OS.has_feature("pc") and not get_window().is_embedded():
		scale_window(4)
