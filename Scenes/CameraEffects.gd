extends Camera3D

@export var shake_freq = 0.0
@export var shake_amplitude = 0.0

var og_pos : Vector3

var rng : RandomNumberGenerator

var last_shake : float
var shake_pos = Vector3.ZERO

var outline_camera : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	og_pos = global_transform.origin
	rng = RandomNumberGenerator.new()
	last_shake = Time.get_unix_time_from_system()
	outline_camera = $OutlineTexture/OutlineCamera as Node3D
	pass # Replace with function body.

func random_point() -> Vector3:
	return Vector3(rng.randf_range(-1.0, 1.0), rng.randf_range(-1.0, 1.0), rng.randf_range(-1.0, 1.0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var current_time = Time.get_unix_time_from_system()
	if shake_freq == 0.0 or shake_amplitude == 0.0:
		global_transform.origin = og_pos
		outline_camera.global_transform = global_transform
		last_shake = current_time
		return
	
	if current_time - last_shake < 1.0 / shake_freq:
		global_transform.origin += (shake_pos - global_transform.origin) * shake_freq * delta
	else:
		last_shake = current_time
		shake_pos = og_pos + (random_point() * shake_amplitude)
		
	outline_camera.global_transform = global_transform
	
	pass
