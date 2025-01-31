extends Node2D


const speed = 60
var direction = 1

@onready var ledge_check_left: RayCast2D = $LedgeCheckLeft
@onready var ledge_check_right: RayCast2D = $LedgeCheckRight
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Applies random direction at start -- can probably delete as enemies will have player detection
	var num = [-1,1]
	direction *= num[randi() % num.size()]
	if direction == 1:
		animated_sprite_2d.flip_h = true
	if direction == -1:
		animated_sprite_2d.flip_h = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Checks if colliding with wall
	if ledge_check_left.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.position.x = 5
	if ledge_check_right.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.position.x = 0
		
	# Play Animations
	if direction == 0:
		animated_sprite_2d.play("Idle")
	else:
		animated_sprite_2d.play("Run")
	

	position.x += direction * speed * delta
	position.y += direction * speed * delta
	
