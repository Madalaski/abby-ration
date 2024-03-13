extends Node3D

@export var projectile : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var arrow = projectile.instantiate()
	get_tree().root.add_child(arrow)
	#get_tree().root.get_node("Main/WorldManager").add_child_to_current_world(arrow)
	arrow.global_basis = global_basis
	arrow.global_position = global_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
