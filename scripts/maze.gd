extends TileMapLayer

@export var pellet_scene: PackedScene

signal pellet_collected

func _ready():
	var pellet_positions = get_used_cells_by_id(1)

	for position in pellet_positions:
		var local_pos = map_to_local(position)
		var pellet = pellet_scene.instantiate()
		pellet.position = local_pos
		pellet.collected.connect(_on_pellet_collected)
		add_child(pellet)
		set_cell(position, -1)

func _on_pellet_collected():
	pellet_collected.emit()
