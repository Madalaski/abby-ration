extends Area3D

@export var direction : int;

var mesh : GeometryInstance3D;
var material : StandardMaterial3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mesh = $MeshInstance3D as GeometryInstance3D
	material = mesh.material_override as StandardMaterial3D
	pass # Replace with function body.

func enable():
	process_mode = Node.PROCESS_MODE_ALWAYS
	material.albedo_color = Color(0.0, 0.0, 0.0)
	show()
	
func disable():
	process_mode = Node.PROCESS_MODE_DISABLED
	material.albedo_color = Color(1.0, 0.0, 0.0)
	show()
	
func hide_door():
	process_mode = Node.PROCESS_MODE_DISABLED
	hide()

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		get_parent().on_player_enter_door(direction)
	pass # Replace with function body.
