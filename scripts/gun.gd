extends Node2D

#Shooting script
@onready var main = get_tree().current_scene
@onready var bullet = load("res://scenes/bullet.tscn")
@onready var player = get_parent().get_node("SwordPlayer")
@onready var healthbar: ProgressBar = $CanvasLayer/Healthbar

func _ready() -> void:
	healthbar.init_health(Livescounter.gun_health)

func shoot():
	var instance = bullet.instantiate()
	instance.dir = rotation
	instance.flipped = sprite_2d.flip_h
	if instance.flipped == 0:
		instance.spawnPos = global_position + Vector2(20,0)
		instance.spawnRot = sprite_2d.rotation
	if instance.flipped == 1:
		instance.spawnPos = global_position + Vector2(-15,0)
		instance.spawnRot = sprite_2d.rotation
	main.add_child.call_deferred(instance)


func _on_timer_timeout() -> void:
	shoot()

const speed = 60
var direction = 1

# Movement script
@onready var ray_cast_left: RayCast2D = $RayCast_left
@onready var ray_cast_right: RayCast2D = $RayCast_right
@onready var sprite_2d: Sprite2D = $Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if direction == 1:
		sprite_2d.position.x = 5
		sprite_2d.look_at(player.position)
	if direction == -1:
		sprite_2d.position.x = -5
		sprite_2d.look_at(player.position)
		sprite_2d.rotation_degrees += 180
		
	if ray_cast_left.is_colliding():
		sprite_2d.flip_h = false
		direction = 1
	if ray_cast_right.is_colliding():
		sprite_2d.flip_h = true
		direction = -1
	
	healthbar.health = Livescounter.gun_health
	position.x += direction * speed * delta
