extends CharacterBody2D

const SPEED = 2
var direction := Vector2(SPEED, 0)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ray_cast_up: RayCast2D = $RayCastUp
@onready var ray_cast_down: RayCast2D = $RayCastDown
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("up"):
		if not ray_cast_up.is_colliding():
			direction = Vector2(0, -SPEED)
			animation_player.assigned_animation = "Up"

	if Input.is_action_pressed("down"):
		if not ray_cast_down.is_colliding():
			direction = Vector2(0, SPEED)
			animation_player.assigned_animation = "Down"
	if Input.is_action_pressed("left"):
		if not ray_cast_left.is_colliding():
			direction = Vector2(-SPEED, 0)
			animation_player.assigned_animation = "Left"
	if Input.is_action_pressed("right"):
		if not ray_cast_right.is_colliding():
			direction = Vector2(SPEED, 0)
			animation_player.assigned_animation = "Right"

	position += direction

	move_and_slide()
