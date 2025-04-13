extends TileMapLayer

@export var pellet_scene: PackedScene

signal pellet_collected

func _ready():
	var pellet_positions = get_used_cells_by_id(1)

	switch_tile_to_scene(1, pellet_scene, _on_pellet_collected)

func _on_pellet_collected():
	pellet_collected.emit()

func switch_tile_to_scene(source_id: int, scene: PackedScene, collectedHandler: Callable) -> void:
	var tile_positions = get_used_cells_by_id(source_id)

	for position in tile_positions:
		var local_pos = map_to_local(position)
		var instance = scene.instantiate()
		instance.position = local_pos
		instance.collected.connect(collectedHandler)
		add_child(instance)
		set_cell(position, -1)
