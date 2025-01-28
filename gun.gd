extends Node2D

#Shooting script
@onready var main = get_tree().get_root().get_node("Game")
@onready var projectile = load("res://bullet.tscn")

func shoot():
	var instance = projectile.instantiate()
	instance.dir = rotation
	instance.spawnPos = global_position
	instance.spawnRot = rotation
	main.add_child.call_deferred(instance)


func _on_timer_timeout() -> void:
	shoot()

const speed = 60
var direction = 1

# Movement script
@onready var ray_cast_left: RayCast2D = $RayCast_left
@onready var ray_cast_right: RayCast2D = $RayCast_right
@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Applies random direction at start -- can probably delete as enemies will have player detection
	var num = [-1,1]
	direction *= num[randi() % num.size()]
	if direction == 1:
		sprite_2d.flip_h = true
	if direction == -1:
		sprite_2d.flip_h = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Checks if colliding with wall
	if ray_cast_left.is_colliding():
		direction = 1
		sprite_2d.flip_h = true
		sprite_2d.position.x = 5
	if ray_cast_right.is_colliding():
		direction = -1
		sprite_2d.flip_h = false
		sprite_2d.position.x = 0
		

	

	position.x += direction * speed * delta
