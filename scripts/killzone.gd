extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	print("HIT")
	if Livescounter.invincibility == 0:
		Livescounter.invincibility = 1
		Livescounter.lives -= 1
		timer.start()
	if Livescounter.lives == 0:
		body.get_node("CollisionShape2D").queue_free()



func _on_timer_timeout() -> void:
	Livescounter.invincibility = 0
