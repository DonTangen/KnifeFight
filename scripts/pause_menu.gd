extends Control
@onready var pause_menu: Control = $"."
@onready var game = get_tree().current_scene

func _ready():
	$AnimationPlayer.play("RESET")
	pause_menu.hide()
	

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")

func pause():
	get_tree().paused = true
	pause_menu.show()
	$AnimationPlayer.play("blur")

func testEsc():
	if Input.is_action_just_pressed("esc") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused == true:
		resume()
		pause_menu.hide()

func _on_resume_pressed() -> void:
	resume()
	pause_menu.hide()

func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _process(_delta):
	testEsc()
