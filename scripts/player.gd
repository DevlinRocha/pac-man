extends CharacterBody2D

const SPEED = 2
var direction := Vector2(SPEED, 0)


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ray_cast_group_up: Node2D = $RayCastGroupUp
@onready var ray_cast_group_down: Node2D = $RayCastGroupDown
@onready var ray_cast_group_left: Node2D = $RayCastGroupLeft
@onready var ray_cast_group_right: Node2D = $RayCastGroupRight


func can_move(ray_group: Node2D) -> bool:
	for ray in ray_group.get_children():
		if ray is RayCast2D and ray.is_colliding():
			return false
	return true


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("up") and can_move(ray_cast_group_up):
		direction = Vector2(0, -SPEED)
		animation_player.assigned_animation = "Up"

	if Input.is_action_pressed("down") and can_move(ray_cast_group_down):
		direction = Vector2(0, SPEED)
		animation_player.assigned_animation = "Down"

	if Input.is_action_pressed("left") and can_move(ray_cast_group_left):
		direction = Vector2(-SPEED, 0)
		animation_player.assigned_animation = "Left"

	if Input.is_action_pressed("right") and can_move(ray_cast_group_right):
		direction = Vector2(SPEED, 0)
		animation_player.assigned_animation = "Right"

	position += direction

	move_and_slide()
