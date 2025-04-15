extends CharacterBody2D

enum GhostType {BLINKY, PINKY, INKY, CLYDE}
enum State {CHASE, SCATTER, FRIGHTENED, EATEN}
enum Direction {UP, DOWN, LEFT, RIGHT}

const DIRECTIONS = [Vector2i.UP, Vector2i.LEFT, Vector2i.DOWN, Vector2i.RIGHT]

var current_state := State.CHASE

@export var ghost_identity: GhostType

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player: CharacterBody2D = %Player
@onready var maze: TileMapLayer = %Maze
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D


@export var normal_speed: float = 1.6
@export var frightened_speed: float = 50.0
@export var eaten_speed: float = 150.0


var current_direction := Vector2i.LEFT
var next_direction := Vector2i.ZERO
var current_tile := Vector2i.ZERO
var target_tile := Vector2i.ZERO


var _move_target_position := Vector2.ZERO
var _is_at_target_position := true

func _ready() -> void:
	change_color()
	current_tile = maze.local_to_map(global_position)
	_update_target_tile()
	_choose_next_direction()


func _physics_process(_delta: float) -> void:
	if _is_at_target_position:
		current_direction = next_direction
		_update_target_tile()
		_choose_next_direction()

	position += global_position.direction_to(_move_target_position) * normal_speed
	current_tile = maze.local_to_map(global_position)
	var next_tile_coords := Vector2i(current_tile + next_direction)
	_move_target_position = maze.map_to_local(next_tile_coords)

	move_and_slide()


func _update_target_tile() -> void:
	match current_state:
		State.CHASE:
			# Blinky targets Pac-Man's current tile directly
			if player:
				target_tile = maze.local_to_map(player.global_position)
			else:
				target_tile = current_tile # Failsafe if player not found
		State.SCATTER:
			#target_tile = BLINKY_SCATTER_TARGET
			pass
		State.FRIGHTENED:
			# Target is irrelevant, movement is random at intersections
			pass
		State.EATEN:
			# Target the ghost house entrance/spawn point
			# target_tile = GHOST_HOUSE_ENTRY_TILE # Define this constant
			pass # Implement Eaten target


func _choose_next_direction() -> void:
	var possible_directions: Array[Vector2i] = []
	var best_direction := Vector2i.ZERO
	var min_dist_sq: float = INF # Use squared distance for efficiency

	# Check potential directions (Up, Left, Down, Right)
	for dir in DIRECTIONS:
		# Rule 1: Cannot reverse direction unless at a dead end
		if dir == -current_direction:
			continue

		# Rule 2: Check if the next tile in this direction is a wall
		var check_tile = current_tile + dir
		if not _is_wall(check_tile):
			possible_directions.append(dir)

	# If only one path (not reversing), must take it (handles corridors and dead ends)
	if possible_directions.size() == 1:
		next_direction = possible_directions[0]
		return

	# If multiple paths (at an intersection):
	if possible_directions.size() > 0:
		if current_state == State.FRIGHTENED:
			# Choose a random valid direction
			next_direction = possible_directions.pick_random()
		else:
			# Choose direction that leads closest to the target_tile
			# Pac-Man Priority: Up > Left > Down > Right
			for dir in possible_directions:
				var potential_next_tile = current_tile + dir
				# Calculate squared distance (faster than sqrt)
				var dist_sq = potential_next_tile.distance_squared_to(target_tile)

				if dist_sq < min_dist_sq:
					min_dist_sq = dist_sq
					best_direction = dir

			next_direction = best_direction
			#print({best_direction = best_direction})
	else:
		# At a dead end, only option is to reverse
		print("DEAD END")
		next_direction = -current_direction


func _is_wall(tile_coords: Vector2i) -> bool:
	var tile_id = maze.get_cell_source_id(tile_coords)
	if tile_id == 0:
		return true
	return false


func change_color() -> void:
	var material: ShaderMaterial = sprite_2d.material
	var ghost_color: Color

	match ghost_identity:
		GhostType.BLINKY:
			ghost_color = Color.RED
		GhostType.PINKY:
			ghost_color = Color.PINK
		GhostType.INKY:
			ghost_color = Color.CYAN
		GhostType.CLYDE:
			ghost_color = Color.ORANGE

	material.set_shader_parameter("new_color", ghost_color)
