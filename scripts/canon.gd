extends Node2D

@onready var main = get_tree().current_scene      #get_root().get_node()
@onready var projectile = load("res://scenes/projectile.tscn")



func shoot():
	var instance = projectile.instantiate()
	instance.dir = rotation
	instance.spawnPos = global_position
	instance.spawnRot = rotation
	main.add_child.call_deferred(instance)


func _on_timer_timeout() -> void:
	shoot()
