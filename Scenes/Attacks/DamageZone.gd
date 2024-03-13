extends Area3D

@export var Damage = 10

func _on_body_entered(body: Node3D) -> void:
	if body.has_node("EnemyDamage"):
		var enemyDamage = body.get_node("EnemyDamage")
		enemyDamage.AddDamage(get_instance_id(), Damage)
