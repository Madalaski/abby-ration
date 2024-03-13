extends Node

@export var Health = 1;

var DamageIDs : Array;
var Damages : Array;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in range(Damages.size()):
		Health -= Damages[i]
	
	Damages.clear()
	DamageIDs.clear()
	
	if (Health <= 0):
		get_parent().kill()
	
	pass

func AddDamage(instance_id : int, damage: int):
	if DamageIDs.find(instance_id) != -1:
		return
	
	DamageIDs.append(instance_id)
	Damages.append(damage)
