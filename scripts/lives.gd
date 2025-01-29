extends CanvasLayer

@onready var timer: Timer = $Timer
@onready var timer2: Timer = $Timer2
var timer1_started
var timer2_started
var heart1
var heart2
var heart3

func _ready() -> void:
	Livescounter.lives = 3

func _physics_process(_delta: float) -> void:
	
	if Livescounter.lives == 2:
		$Life3.hide()
		if !heart3:
			$Hit3.play("Hit Heart")
			heart3 = 1
			timer2.start()
			timer2_started = 1
	if Livescounter.lives == 1:
		$Life2.hide()
		if !heart2:
			$Hit2.play("Hit Heart")
			heart2 = 1
			timer2.start()
			timer2_started = 1
	if Livescounter.lives == 0:
		$Life1.hide()
		if !heart1:
			$Hit1.play("Hit Heart")
			heart1 = 1
			timer2.start()
			timer2_started = 1
		print("You died!")
		Engine.time_scale = 0.5
		if !timer1_started:
			timer.start()
			timer1_started = 1

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	timer1_started = 0
	heart3 = 0
	heart2 = 0
	heart1 = 0
	get_tree().reload_current_scene()


func _on_timer_2_timeout() -> void:
	timer2_started = 0
	if Livescounter.lives == 2:
		$Hit3.hide()
	if Livescounter.lives == 1:
		$Hit2.hide()
	if Livescounter.lives == 0:
		$Hit1.hide()
