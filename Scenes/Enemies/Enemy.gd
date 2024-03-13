extends RigidBody3D

signal enemy_died

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func kill():
	emit_signal("enemy_died")
	queue_free()