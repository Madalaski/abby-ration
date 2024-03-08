extends RigidBody3D

var movement_disabled = false

var combat : Node
var movement : Node

var grounded = true

func _ready():
	combat = $Combat as Node
	movement = $Movement as Node

func _physics_process(delta):
	if combat == null or movement == null:
		return
	
	var prev_grounded = grounded
	grounded = check_grounded()
	if prev_grounded == false and grounded == true:
		combat.hit_ground()

func check_grounded():
	var space_state = get_world_3d().direct_space_state

	var origin = global_transform.origin
	var end = origin + (Vector3.DOWN * 1.5)
	var query = PhysicsRayQueryParameters3D.create(origin, end)

	var result = space_state.intersect_ray(query)
	return result.is_empty() == false

func enable_movement():
	movement_disabled = false

func disable_movement():
	movement_disabled = true
