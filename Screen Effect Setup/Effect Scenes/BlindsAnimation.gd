extends Node3D

@export var movementCurve : Curve;

var left : Node2D
var right : Node2D

var leftStartX : float
var rightStartX : float
var startTime : float

var playing = false

func play():
	left = $Blinds/LeftBlind as Node2D
	right = $Blinds/RightBlind as Node2D
	
	leftStartX = left.transform.origin.x;
	rightStartX = right.transform.origin.x;
	
	startTime = Time.get_unix_time_from_system()
	playing = true
	
func _process(delta):
	
	if playing == false:
		return
	
	var currentTime = Time.get_unix_time_from_system()
	left.position.x = leftStartX - movementCurve.sample_baked(currentTime - startTime)
	right.position.x = rightStartX + movementCurve.sample_baked(currentTime - startTime)
	pass
