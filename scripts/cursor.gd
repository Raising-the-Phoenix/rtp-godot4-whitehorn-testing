extends CanvasLayer

@export var cursor_texture: Texture2D
@export var ibeam_texture: Texture2D
@export var highlight_texture: Texture2D
@export var tile_size: int = 32

var tilemap_layer: TileMapLayer = null
var is_ibeam: bool = false

# --- Helper: Recursive search for a TileMapLayer in the scene ---
func _find_tilemap(node: Node) -> TileMapLayer:
	if node is TileMapLayer:
		return node
	for child in node.get_children():
		if child != null:
			var found = _find_tilemap(child)
			if found != null:
				return found
	return null

# --- Helper: Switch cursor textures ---
func _set_cursor_to_ibeam():
	if ibeam_texture:
		$CursorSprite.texture = ibeam_texture
	is_ibeam = true

func _set_cursor_to_normal():
	if cursor_texture:
		$CursorSprite.texture = cursor_texture
	is_ibeam = false

# --- Highlight a tile under the mouse (if TileMap exists) ---
func _highlight_tile_under_cursor(mouse_pos: Vector2) -> void:
	if tilemap_layer == null:
		return

	var local_pos = tilemap_layer.to_local(mouse_pos)
	var cell = tilemap_layer.local_to_map(local_pos)
	var tile_pos = tilemap_layer.map_to_local(cell)

	$TileHighlight.global_position = tilemap_layer.to_global(tile_pos).snapped(Vector2(tile_size, tile_size))

# --- Godot lifecycle ---
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

	if cursor_texture:
		$CursorSprite.texture = cursor_texture
	if highlight_texture:
		$TileHighlight.texture = highlight_texture

	$CursorSprite.visible = true
	$TileHighlight.visible = true

func _process(_delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	$CursorSprite.global_position = mouse_pos

	# --- Cursor switching logic ---
	var hovered = get_viewport().gui_get_hovered_control()
	if hovered != null and (hovered is LineEdit or hovered is TextEdit):
		if not is_ibeam:
			_set_cursor_to_ibeam()
	else:
		if is_ibeam:
			_set_cursor_to_normal()

	# --- Tile highlighting logic ---
	if tilemap_layer == null:
		var scene = get_tree().current_scene
		if scene != null:
			tilemap_layer = _find_tilemap(scene)

	if tilemap_layer:
		_highlight_tile_under_cursor(mouse_pos)
