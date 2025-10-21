extends CanvasLayer

@export var cursor_texture: Texture2D
@export var highlight_texture: Texture2D
@export var tile_size: int = 32

var tilemap_layer: TileMapLayer = null

func _ready() -> void:
	# Hide system cursor
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

	# Assign textures
	if cursor_texture:
		$CursorSprite.texture = cursor_texture
	if highlight_texture:
		$TileHighlight.texture = highlight_texture

	$CursorSprite.visible = true
	$TileHighlight.visible = true

func _process(_delta: float) -> void:
	# Move cursor sprite
	var mouse_pos = get_viewport().get_mouse_position()
	$CursorSprite.global_position = mouse_pos

	# Find tilemap in the current scene if not already set
	if tilemap_layer == null:
		var scene = get_tree().current_scene
		if scene != null:
			tilemap_layer = _find_tilemap(scene)

	# Highlight the tile under the cursor
	if tilemap_layer:
		_highlight_tile_under_cursor(mouse_pos)

# Highlight tile under mouse
func _highlight_tile_under_cursor(mouse_pos: Vector2) -> void:
	# Convert mouse position to TileMap coordinates
	var local_pos = tilemap_layer.to_local(mouse_pos)
	var cell = tilemap_layer.local_to_map(local_pos)
	var tile_pos = tilemap_layer.map_to_local(cell)

	# Snap the highlight sprite to the tile
	$TileHighlight.global_position = tilemap_layer.to_global(tile_pos).snapped(Vector2(tile_size, tile_size))

# Recursive search for TileMapLayer
func _find_tilemap(node: Node) -> TileMapLayer:
	if node is TileMapLayer:
		return node
	for child in node.get_children():
		if child != null:
			var found = _find_tilemap(child)
			if found != null:
				return found
	return null
