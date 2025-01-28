extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	print("HIT")
	Livescounter.lives -= 1
	if Livescounter.lives == 0:
		body.get_node("CollisionShape2D").queue_free()
