extends Node

class_name Movement

@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")
@onready var _spring_arm: SpringArm3D = %SpringArm3D
@onready var gravity = GameData.gravity
@onready var fall_gravity = GameData.fall_gravity

@export var speed = 14

@export var JUMP_VELOCITY = 4.5
var target_velocity = Vector3.ZERO

func _physics_process(delta):
	if not player.is_on_floor():
		target_velocity.y -= get_gravity(player.velocity) * delta
		
	if Input.is_action_just_released("jump") and target_velocity.y > 0:
		target_velocity.y = JUMP_VELOCITY / 4

	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		target_velocity.y = JUMP_VELOCITY
		
	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_direction.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	move_direction = move_direction.rotated(Vector3.UP, _spring_arm.rotation.y).normalized()

	if move_direction != Vector3.ZERO:
		move_direction = move_direction.normalized()
	
	target_velocity.x = move_direction.x * speed
	target_velocity.z = move_direction.z * speed
	
	player.velocity = target_velocity
	player.move_and_slide()

func get_gravity(velocity:Vector3) -> float:
	if velocity.y > 0:
		return gravity
	return fall_gravity
