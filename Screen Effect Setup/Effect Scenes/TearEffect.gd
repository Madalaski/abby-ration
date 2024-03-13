extends Node3D

@export var speed = 1.2

var time_start = 0.0
var playing = false

var map : Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if playing == false:
		return
	
	var current_time = Time.get_unix_time_from_system()
	
	var mat = map.material as ShaderMaterial
	mat.set_shader_parameter("progress", (current_time - time_start) * speed)
	
	pass
	
func play():
	map = $Map
	time_start = Time.get_unix_time_from_system()
	playing = true
