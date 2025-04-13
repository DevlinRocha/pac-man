extends TileMapLayer

const PELLET = preload("res://scenes/pellet.tscn")
const POWER_PELLET = preload("res://scenes/power_pellet.tscn")

signal pellet_collected
signal power_pellet_collected

func _ready():
	var pellet_positions = get_used_cells_by_id(1)
	var power_pellet_positions = get_used_cells_by_id(2)

	switch_tile_to_scene(1, PELLET, _on_pellet_collected)
	switch_tile_to_scene(2, POWER_PELLET, _on_power_pellet_collected)

func _on_pellet_collected():
	pellet_collected.emit()

func _on_power_pellet_collected():
	power_pellet_collected.emit()

func switch_tile_to_scene(source_id: int, scene: PackedScene, collectedHandler: Callable) -> void:
	var tile_positions = get_used_cells_by_id(source_id)

	for position in tile_positions:
		var local_pos = map_to_local(position)
		var instance = scene.instantiate()
		instance.position = local_pos
		instance.collected.connect(collectedHandler)
		add_child(instance)
		set_cell(position, -1)
