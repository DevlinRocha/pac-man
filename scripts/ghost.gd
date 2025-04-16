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
@onready var blinky: CharacterBody2D = $"."


@export var normal_speed: float = 1.6
@export var frightened_speed: float = 50.0
@export var eaten_speed: float = 150.0


func _ready() -> void:
	change_color()
	_update_target_tile()


func _physics_process(_delta: float) -> void:
	if navigation_agent_2d.is_target_reached():
		_update_target_tile()

	var direction = navigation_agent_2d.get_next_path_position() - global_position
	direction = snapped(Vector2(direction.normalized()), Vector2(1, 1))
	position += direction * normal_speed


func _update_target_tile() -> void:
	match current_state:
		State.CHASE:
			match ghost_identity:
				GhostType.BLINKY:
					# Blinky targets Pac-Man's current tile directly
					navigation_agent_2d.target_position = player.global_position
				GhostType.PINKY:
					# Pinky targets 4 tiles ahead of Pac-Man's current tile
					navigation_agent_2d.target_position = player.global_position + (player.current_direction * 4)
				GhostType.INKY:
					# Inky
					var tile_ahead = player.global_position + (player.current_direction * 2)
					var distance = tile_ahead - blinky.position
					var new_target = blinky.position + (distance * 2)
					navigation_agent_2d.target_position.x = clamp(new_target.x, 368, 784)
					navigation_agent_2d.target_position.y = clamp(new_target.y, 16, 480)
				GhostType.CLYDE:
					# Clyde
					pass
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
	navigation_agent_2d.debug_path_custom_color = ghost_color
