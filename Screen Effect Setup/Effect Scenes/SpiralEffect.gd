extends Node3D

@export var movementCurve : Curve

var spiralModel : Node3D
var spiralStartY : float
var startTime : float

var playing = false

func play():
	spiralModel = $SpiralEffectModel as Node3D
	spiralStartY = spiralModel.transform.origin.y
	startTime = Time.get_unix_time_from_system()
	playing = true

func _process(delta):
	if playing == false:
		return
	
	var currentTime = Time.get_unix_time_from_system()
	
	spiralModel.transform.origin.y = spiralStartY + movementCurve.sample_baked(currentTime - startTime)
