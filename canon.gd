extends Node2D

@onready var main = get_tree().get_root().get_node("World")
@onready var projectile = load("res://projectile.tscn")



func shoot():
	var instance = projectile.instantiate()
	instance.dir = rotation
	instance.spawnPos = global_position
	instance.spawnRot = rotation
	main.add_child.call_deferred(instance)


func _on_timer_timeout() -> void:
	shoot()
