extends Area2D


func _ready() -> void:
	body_exited.connect(_on_body_exited)

func _on_body_exited(body: Node2D) -> void:
	print(body)
	print(body.position.x)
	if body.position.x > 800:
		print("right")
		body.position.x = 340.0
	elif body.position.x > 341:
		print("left")
		body.position.x = 800.0
