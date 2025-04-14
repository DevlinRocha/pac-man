extends CharacterBody2D

enum Direction {UP, DOWN, LEFT, RIGHT}

const SPEED = 2

var current_direction := Vector2.RIGHT

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ray_cast_group_up: Node2D = $RayCastGroupUp
@onready var ray_cast_group_down: Node2D = $RayCastGroupDown
@onready var ray_cast_group_left: Node2D = $RayCastGroupLeft
@onready var ray_cast_group_right: Node2D = $RayCastGroupRight


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("up") and can_move(Vector2.UP):
		current_direction = Vector2.UP
		animation_player.assigned_animation = "Up"

	if Input.is_action_pressed("down") and can_move(Vector2.DOWN):
		current_direction = Vector2.DOWN
		animation_player.assigned_animation = "Down"

	if Input.is_action_pressed("left") and can_move(Vector2.LEFT):
		current_direction = Vector2.LEFT
		animation_player.assigned_animation = "Left"

	if Input.is_action_pressed("right") and can_move(Vector2.RIGHT):
		current_direction = Vector2.RIGHT
		animation_player.assigned_animation = "Right"

	position += current_direction * SPEED
	if can_move(current_direction):
		animation_player.play()
	else:
		animation_player.stop()

	move_and_slide()


func can_move(new_direction: Vector2) -> bool:
	var ray_group: Node2D
	match new_direction:
		Vector2.UP:
			ray_group = ray_cast_group_up
		Vector2.DOWN:
			ray_group = ray_cast_group_down
		Vector2.LEFT:
			ray_group = ray_cast_group_left
		Vector2.RIGHT:
			ray_group = ray_cast_group_right

	for ray in ray_group.get_children():
		if ray is RayCast2D and ray.is_colliding():
			return false
	return true
