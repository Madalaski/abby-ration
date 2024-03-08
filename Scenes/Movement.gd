extends Node

@export var moveSpeed : float
var player : RigidBody3D

func _ready():
	player = get_parent()

func _physics_process(delta):
	
	if player.movement_disabled:
		return
	
	var input_direction = Vector3.ZERO
	
	if Input.is_action_pressed("Left"):
		input_direction += Vector3(-1, 0, 0)
	if Input.is_action_pressed("Right"):
		input_direction += Vector3(1, 0, 0)
	if Input.is_action_pressed("Up"):
		input_direction += Vector3(0, 0, -1)
	if Input.is_action_pressed("Down"):
		input_direction += Vector3(0, 0, 1)
	
	if input_direction.length_squared() > 1.0:
		input_direction = input_direction.normalized()	
	
	if input_direction.length_squared() > 0.0:
		player.rotate_y(player.basis.z.signed_angle_to(player.linear_velocity, Vector3.UP) * delta * 14.0)
	
	player.apply_force(input_direction * moveSpeed);
