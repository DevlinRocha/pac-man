extends CharacterBody2D

const SPEED = 4
var direction := Vector2(SPEED, 0)

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("up"):
		direction = Vector2(0, -SPEED)
	if Input.is_action_pressed("down"):
		direction = Vector2(0, SPEED)
	if Input.is_action_pressed("left"):
		direction = Vector2(-SPEED, 0)
	if Input.is_action_pressed("right"):
		direction = Vector2(SPEED, 0)

	position += direction

	move_and_slide()
