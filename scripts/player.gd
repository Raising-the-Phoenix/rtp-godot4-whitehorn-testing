extends Node2D

# --- Grid Movement Variables ---
const TILE_SIZE := 32
const MOVE_DURATION := 0.15

@export var tilemap_layer: TileMapLayer   # Drag your TileMapLayer node here

var is_moving: bool = false
var target_position: Vector2

func _ready() -> void:
	if tilemap_layer == null:
		push_error("TileMapLayer not assigned! Please drag your TileMapLayer node into the Player's 'tilemap_layer' export slot.")
		return

	target_position = position


func _physics_process(_delta: float) -> void:
	if is_moving:
		return


func _unhandled_input(event: InputEvent) -> void:
	if is_moving:
		return

	var move_direction := Vector2.ZERO

	# Cardinal directions
	if event.is_action_pressed("ui_right"):
		move_direction = Vector2.RIGHT
	elif event.is_action_pressed("ui_left"):
		move_direction = Vector2.LEFT
	elif event.is_action_pressed("ui_up"):
		move_direction = Vector2.UP
	elif event.is_action_pressed("ui_down"):
		move_direction = Vector2.DOWN

	# Diagonals
	elif event.is_action_pressed("move_up_right"):
		move_direction = Vector2(1, -1)
	elif event.is_action_pressed("move_up_left"):
		move_direction = Vector2(-1, -1)
	elif event.is_action_pressed("move_down_right"):
		move_direction = Vector2(1, 1)
	elif event.is_action_pressed("move_down_left"):
		move_direction = Vector2(-1, 1)

	if move_direction == Vector2.ZERO:
		return

	var new_target := position + move_direction * TILE_SIZE
	var target_cell := tilemap_layer.local_to_map(new_target)

	# Check if the tile is walkable
	if not is_tile_walkable(target_cell):
		return

	is_moving = true
	target_position = new_target
	start_grid_move(target_position)


func is_tile_walkable(cell: Vector2i) -> bool:
	# Get tile source id from the TileMapLayer
	var source_id := tilemap_layer.get_cell_source_id(cell)
	if source_id == -1:
		# Empty = walkable
		return true

	# Optional metadata check
	var data := tilemap_layer.get_cell_tile_data(cell)
	if data and data.has_custom_data("walkable"):
		return data.get_custom_data("walkable")

	return false


func start_grid_move(destination: Vector2) -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", destination, MOVE_DURATION)
	tween.finished.connect(_on_move_finished)


func _on_move_finished() -> void:
	is_moving = false
	position = target_position
