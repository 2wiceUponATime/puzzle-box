extends TileMapLayer

@onready var player: Sprite2D = $"../Player"
var air_tiles: int

func load_level(level: Global.Level):
	var width := level.size.x
	var height := level.size.y
	air_tiles = width * height
	var wall := Global.tile_wall
	for x in range(width):
		wall.set_cell(self, Vector2i(x, -1))
		wall.set_cell(self, Vector2i(x, height))
	for y in range(height):
		wall.set_cell(self, Vector2i(-1, y))
		wall.set_cell(self, Vector2i(width, y))
	for pos in level.tiles.keys():
		var type = level.tiles[pos]
		if type != Global.TileType.AIR:
			air_tiles -= 1
		Global.get_tile(type).set_cell(self, pos)
	player.level_pos = level.player_pos
	player.position = player.level_to_parent(level.player_pos)

func _ready() -> void:
	load_level.call_deferred(Global.level)
