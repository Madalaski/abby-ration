extends Node3D

@export var speed = 2;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += global_basis.z * speed * delta;
	pass

func _on_area_body_entered(body: Node3D) -> void:
	if (body is StaticBody3D):
		queue_free()
	pass # Replace with function body.
