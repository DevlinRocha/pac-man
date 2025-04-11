extends CharacterBody2D

const SPEED = 2
var direction := Vector2(SPEED, 0)

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("up"):
		direction = Vector2(0, -SPEED)
		animation_player.assigned_animation = "Up"
	if Input.is_action_pressed("down"):
		direction = Vector2(0, SPEED)
		animation_player.assigned_animation = "Down"
	if Input.is_action_pressed("left"):
		direction = Vector2(-SPEED, 0)
		animation_player.assigned_animation = "Left"
	if Input.is_action_pressed("right"):
		direction = Vector2(SPEED, 0)
		animation_player.assigned_animation = "Right"

	position += direction

	move_and_slide()
