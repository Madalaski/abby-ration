extends Node3D

var levelData : Dictionary

var currentWorld = 0
var worldRooms : Array
var worldDirections : Array

var current_location : String
var player : Node3D

func _ready():
	player = get_node("../Player")
	worldRooms = [$Room_World0, $Room_World1, $Room_World2, $Room_World3]
	for room in worldRooms:
		var base_room = room.get_node("BaseRoom")
		base_room.change_location.connect(change_rooms)
		base_room.kill_enemy.connect(kill_enemy)
	
	worldDirections = [Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(1, 0, 0), Vector3(0, 0, -1)]
	
	var file = FileAccess.open("res://Data/LevelData.json", FileAccess.READ)
	levelData = JSON.parse_string(file.get_as_text())
	load_room("0")

func switch_world_rooms(new_world : int):
	worldRooms[currentWorld].transform.origin = 1000.0 * worldDirections[currentWorld]
	worldRooms[new_world].transform.origin = Vector3.ZERO
	currentWorld = new_world

func get_coord_in_world(coord: Vector3, world : int) -> Vector3:
	if world == currentWorld:
		return coord
	
	return coord + 1000.0 * worldDirections[world]

func add_child_to_current_world(node: Node):
	worldRooms[currentWorld].add_child(node)

func change_rooms(new_id : String, direction : int):
	var new_locations = [Vector3(0, 1, 6.5), Vector3(-9, 1, 0), Vector3(0, 1, -6.5), Vector3(9, 1, 0)]
	load_room(new_id)
	player.transform.origin = new_locations[direction]

func kill_enemy(dimension : int):
	var room_data = levelData[current_location]["dimensions"]["%d" % dimension]
	if room_data == null:
		return
	if room_data.has("dead_enemies") == false:
		room_data["dead_enemies"] = 0
	room_data["dead_enemies"] += 1

func load_room(id : String):
	current_location = id
	var room_data = levelData[id]
	
	for i in range(4):
		if room_data["dimensions"].has("%d" % i):
			worldRooms[i].get_node("BaseRoom").load_room(room_data["dimensions"]["%d" % i])
		else:
			worldRooms[i].get_node("BaseRoom").load_room(Dictionary())
