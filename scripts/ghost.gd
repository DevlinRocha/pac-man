extends CharacterBody2D

enum GhostType {BLINKY, PINKY, INKY, CLYDE}

@export var ghost_identity: GhostType

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	change_color()


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
