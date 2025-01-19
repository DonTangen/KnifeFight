extends Node2D

const speed = 60
var direction = 1

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Applies random direction at start -- can probably delete as enemies will have player detection
	var num = [-1,1]
	direction *= num[randi() % num.size()]
	if direction == 1:
		animated_sprite.flip_h = true
	if direction == -1:
		animated_sprite.flip_h = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Checks if colliding with wall
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = true
		animated_sprite.position.x = 5
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = false
		animated_sprite.position.x = 0
		
	# Play Animations
	if direction == 0:
		animated_sprite.play("Idle")
	else:
		animated_sprite.play("Run")
	

	position.x += direction * speed * delta
