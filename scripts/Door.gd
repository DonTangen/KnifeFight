extends Area2D

@onready var timer: Timer = $Timer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var tutorial = load("res://scenes/tutorial.tscn")
var level2 = load("res://scenes/node_2d.tscn")
var boss_level = load("res://scenes/boss_level.tscn")
var on_door = 0
var new_scene = 0

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack-deflect") and on_door == 1:
		animated_sprite.play("Opening")
		timer.start()
	if new_scene == 0:
		animated_sprite.play("Closing")
	new_scene = 1


func _on_area_entered(_area: Area2D) -> void:
	on_door = 1


func _on_area_exited(_area: Area2D) -> void:
	on_door = 0

func _on_timer_timeout() -> void:
	if get_tree().current_scene.name == "tutorial":
		get_tree().change_scene_to_file("res://scenes/node_2d.tscn")
	elif get_tree().current_scene.name == "vertical level":
		get_tree().change_scene_to_file("res://scenes/boss_level.tscn")
