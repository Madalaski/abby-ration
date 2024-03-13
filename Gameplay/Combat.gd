extends Node

@export var attackForces : Array
@export var attackTimes : Array
@export var attackDamps = [0.5, 0.5, 0.5, 0.5]
@export var jumpForce : float
@export var attackScenes : Array

var player : RigidBody3D
var ScreenEffectManager : Node3D
var cam : Camera3D
var weaponPivot : Node3D

var attacking = false
var last_attack_time = 0.0
var last_attack = 0

var start_damp : float

func _ready():
	ScreenEffectManager = get_node("../../ScreenEffectManager") as Node3D
	cam = get_node("../../Camera3D") as Camera3D
	weaponPivot = get_node("../WeaponPivot") as Node3D
	player = get_parent() as RigidBody3D
	start_damp = player.linear_damp
	pass
	
func _process(delta):
	var current_time = Time.get_unix_time_from_system()
	
	if attacking == false:
		if Input.is_action_just_pressed("Attack0"):
			attack(0)
		elif Input.is_action_just_pressed("Attack1"):
			attack(1)
		elif Input.is_action_just_pressed("Attack2"):
			attack(2)
		elif Input.is_action_just_pressed("Attack3"):
			attack(3)
	else:
		if current_time - last_attack_time > attackTimes[last_attack]:
			attacking = false
			player.enable_movement()
			player.linear_damp = start_damp
			if last_attack == 2:
				cam.shake_freq = 0.0
				cam.shake_amplitude = 0.0
			
			if weaponPivot.get_child_count() > 0:
				for child in weaponPivot.get_children():
					child.queue_free()
	
	pass
	
func attack(weapon : int):
	attacking = true
	player.disable_movement()
	player.linear_velocity = Vector3.ZERO
	player.linear_damp = attackDamps[weapon]
	last_attack = weapon
	last_attack_time = Time.get_unix_time_from_system()
	
	if weapon < attackScenes.size() && weapon != 2:
		var attack_scene = attackScenes[weapon].instantiate()
		weaponPivot.add_child(attack_scene)
	player.apply_force(attackForces[weapon] * player.basis.z)
	
	if weapon == 2:
		player.apply_force(jumpForce * Vector3.UP)
		return
	
	var screen_size = get_viewport().get_visible_rect().size
	var screen_pos = cam.unproject_position(get_parent().global_transform.origin)
	screen_pos.x /= screen_size.x
	screen_pos.y /= screen_size.y
	var screen_angle = Vector3.FORWARD.signed_angle_to(get_parent().basis.z, Vector3.UP)
	ScreenEffectManager.call_deferred("start_transition", weapon, screen_pos, screen_angle)
	
func hit_ground():
	if last_attack == 2:
		cam.shake_freq = 20.0
		cam.shake_amplitude = 0.2
		var attack_scene = attackScenes[2].instantiate()
		weaponPivot.add_child(attack_scene)
		var screen_size = get_viewport().get_visible_rect().size
		var screen_pos = cam.unproject_position(get_parent().global_transform.origin)
		screen_pos.x /= screen_size.x
		screen_pos.y /= screen_size.y
		ScreenEffectManager.call_deferred("start_transition", 2, screen_pos, 0)
