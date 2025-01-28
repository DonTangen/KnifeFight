extends Area2D

var tutorial = load("res://scenes/tutorial.tscn")
#const level2 = get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
var boss_level = load("res://scenes/boss_level.tscn")
var on_door = 0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack-deflect") and on_door == 1:
		print("tried to open door")
		print(get_tree().get_root())
		if get_tree().current_scene.name == "tutorial":
			print("changing level")
			get_tree().change_scene_to_file("res://scenes/boss_level.tscn")



func _on_area_entered(area: Area2D) -> void:
	on_door = 1


func _on_area_exited(area: Area2D) -> void:
	on_door = 0
