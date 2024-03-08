extends Node3D

var animation : AnimationPlayer

func play():
	call_deferred("play_deferred")
	
func play_deferred():
	animation = $GlassShatter_Animated/AnimationPlayer as AnimationPlayer
	animation.play("KeyAction")
