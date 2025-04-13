extends CharacterBody2D

enum GhostType {BLINKY, PINKY, INKY, CLYDE}
enum State {CHASE, SCATTER, FRIGHTENED, EATEN}
enum Direction {UP, DOWN, LEFT, RIGHT}

var current_state := State.SCATTER

@export var ghost_identity: GhostType

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player: CharacterBody2D = %Player
@onready var maze: TileMapLayer = %Maze


@export var normal_speed: float = 80.0
@export var frightened_speed: float = 50.0
@export var eaten_speed: float = 150.0


var current_direction := Vector2.LEFT
var next_direction := Vector2.ZERO
var target_tile := Vector2i.ZERO
var current_tile := Vector2i.ZERO


func _ready() -> void:
	change_color()
	_update_target_tile()
	_choose_next_direction()


func _physics_process(_delta: float) -> void:
	move_and_slide()


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
	return


func _is_wall(tile_coords: Vector2i) -> bool:
	var tile_id = maze.get_cell_source_id(tile_coords)
	if tile_id == 0:
		return true
	return false
