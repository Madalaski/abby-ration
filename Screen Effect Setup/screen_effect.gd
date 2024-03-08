extends Node3D

@export var effect_scenes : Array
@export var screenshot : Texture
@export var effect_time = 1.0
@export var effect_position = Vector2(0.5, 0.5)
@export var effect_rotation = 0.0

var quad : ColorRect
var video : VideoStreamPlayer
var effect_scene : Node3D

var timer : Timer

func play(effect_index : int):
	var scene = effect_scenes[effect_index] as PackedScene
	effect_scene = scene.instantiate()
	$SubViewport.add_child(effect_scene)
	call_deferred("play_deferred", effect_index)

func play_deferred(effect_index : int):
	quad = $"Display Quad"
	timer = $"Timer"
	var material = quad.get_material() as ShaderMaterial
	var image = Image.load_from_file("res://screenshot.jpg")
	var texture = ImageTexture.create_from_image(image)
	material.set_shader_parameter("screenshot", texture)
	material.set_shader_parameter("position", effect_position)
	material.set_shader_parameter("rotation", effect_rotation)
	quad.set_material(material)
	
	quad.show()
	timer.timeout.connect(destroy)
	timer.start(effect_time)
	call_deferred("start_anim")
	
func start_anim():
	effect_scene.play()

func destroy():
	quad.hide()
	queue_free()
