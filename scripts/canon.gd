extends Node2D

@onready var main = get_tree().get_root().get_node("tutorial")
@onready var projectile = load("res://projectile.tscn")
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.play("idle")

func shoot():
	var instance = projectile.instantiate()
	instance.dir = rotation
	instance.spawnPos = global_position
	instance.spawnRot = rotation
	main.add_child.call_deferred(instance)


func _on_timer_timeout() -> void:
	shoot()
	animated_sprite_2d.play("shoot")
