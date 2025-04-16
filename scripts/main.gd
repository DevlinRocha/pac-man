extends Node

@onready var maze: TileMapLayer = %Maze
@onready var ui: Control = $UI


func _ready() -> void:
	maze.pellet_collected.connect(_on_pellet_collected)
	maze.power_pellet_collected.connect(_on_power_pellet_collected)

func _on_pellet_collected() -> void:
	ui.increase_score(10)

func _on_power_pellet_collected() -> void:
	ui.increase_score(50)
