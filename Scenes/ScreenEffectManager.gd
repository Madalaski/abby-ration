extends Node3D

@export var screen_effect : PackedScene

var current_world = 0;
var world_effects : Array;

var rng : RandomNumberGenerator;

var worldManager : Node3D

func _ready():
	rng = RandomNumberGenerator.new();
	world_effects = [$World0Effect, $World1Effect, $World2Effect, $World3Effect]
	world_effects[0].show()
	worldManager = get_node("../WorldManager")

func start_transition(new_world : int, _position : Vector2, _rotation : float):
	if new_world == current_world:
		return
	
	var img = get_viewport().get_texture().get_image()
	img.save_jpg("res://screenshot.jpg")
	#var text = ImageTexture.new()
	#text.resource_path = "res://screenshot.jpg"
	
	var instance = screen_effect.instantiate()
	instance.effect_position = _position
	instance.effect_rotation = _rotation
	add_child(instance)
	instance.play(new_world)
	
	world_effects[current_world].hide()
	world_effects[new_world].show()
	worldManager.switch_world_rooms(new_world)
	current_world = new_world
	
#func _input(event):
	#if event is InputEventMouseButton:
		#if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			#var screen_size = get_viewport().get_visible_rect().size
			#var screen_pos = Vector2(event.position.x / screen_size.x, event.position.y / screen_size.y)
			#start_transition(1 if current_world == 0 else 0, screen_pos, rng.randf_range(0.0, 2.0 * PI))
