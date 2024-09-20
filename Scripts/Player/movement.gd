extends Node

class_name Movement

@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")
@onready var _spring_arm: SpringArm3D = %SpringArm3D
@onready var fall_acceleration = GameData.gravity

@export var speed = 14

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	var move_direction = Vector3.ZERO
	move_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_direction.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	move_direction = move_direction.rotated(Vector3.UP, _spring_arm.rotation.y).normalized()


	if move_direction != Vector3.ZERO:
		move_direction = move_direction.normalized()

	# Ground Velocity
	target_velocity.x = move_direction.x * speed
	target_velocity.z = move_direction.z * speed

	if not player.is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	player.velocity = target_velocity
	player.move_and_slide()
