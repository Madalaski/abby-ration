extends Node3D

var currentWorld = 0
var worldRooms : Array
var worldDirections : Array

var player : Node3D

func _ready():
	player = get_node("../Player")
	worldRooms = [$Room_World0, $Room_World1, $Room_World2]
	worldDirections = [Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(1, 0, 0), Vector3(0, 0, -1)]

func switch_world_rooms(new_world : int):
	worldRooms[currentWorld].transform.origin = 1000.0 * worldDirections[currentWorld]
	worldRooms[new_world].transform.origin = Vector3.ZERO
	currentWorld = new_world

func get_coord_in_world(coord: Vector3, world : int) -> Vector3:
	if world == currentWorld:
		return coord
	
	return coord + 1000.0 * worldDirections[world]
