extends Node3D

signal change_location
signal kill_enemy

@export var dimension : int
@export var enemy_template : PackedScene

var door_locations : Dictionary
var door_conditions = false
var dead_enemies = 0
var no_of_enemies = 0;
var rng : RandomNumberGenerator

var directions = ["N", "E", "S", "W"]

var spawned : Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng = RandomNumberGenerator.new()
	spawned = $"../Spawned"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if door_conditions == false:
		return
	
	for i in range(4):
		var door_name = "Door_%s" % directions[i]
		var door_node = get_node(door_name) as Area3D
		
		if door_node.visible == false:
			continue
		
		if dead_enemies >= no_of_enemies:
			door_node.enable()
			door_node.process_mode = Node.PROCESS_MODE_ALWAYS
		else:
			door_node.disable()
			door_node.process_mode = Node.PROCESS_MODE_DISABLED
	
	pass

func random_place_in_room(y_offset : float) -> Vector3:
	return Vector3(rng.randf_range(-9.0, 9.0), y_offset, rng.randf_range(-7.0, 7.0))

func load_room(room_data : Dictionary):
	for child in spawned.get_children():
		child.queue_free()
	
	door_conditions = false
	if room_data != null and room_data.has("door_conditions"):
		door_conditions = room_data["door_conditions"]
	
	dead_enemies = 0
	if room_data != null and room_data.has("dead_enemies"):
		dead_enemies = room_data["dead_enemies"]
	
	no_of_enemies = 0
	if room_data != null and room_data.has("enemies"):
		var enemies = room_data["enemies"]
		no_of_enemies = enemies
		for i in range(enemies - dead_enemies):
			var enemy = enemy_template.instantiate() as Node3D
			spawned.add_child(enemy)
			enemy.transform.origin = random_place_in_room(1.0)
			enemy.enemy_died.connect(enemy_died)
	
	var doors = null
	if room_data != null and room_data.has("doors"):
		doors = room_data["doors"] as Dictionary
	for i in range(4):
		var door_name = "Door_%s" % directions[i]
		var door_node = get_node(door_name) as Area3D
		
		if doors != null and doors.has(directions[i]):
			door_locations[i] = doors[directions[i]]
			if door_conditions:
				if dead_enemies >= no_of_enemies:
					door_node.call_deferred("enable")
				else:
					door_node.call_deferred("disable")
			else:
				door_node.call_deferred("enable")
			
		else:
			door_node.call_deferred("hide_door")

func on_player_enter_door(dir: int):
	var new_location = door_locations[dir]
	emit_signal("change_location", new_location, dir)
	pass
	
func enemy_died():
	dead_enemies += 1
	emit_signal("kill_enemy", dimension)
