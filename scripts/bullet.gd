extends CharacterBody2D

@export var SPEED = 150
@onready var bullet: Sprite2D = $Bullet
@onready var player = get_parent().get_node("SwordPlayer")

var dir : float
var spawnPos : Vector2
var spawnRot : float
var flipped : int
var is_shot = 0

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	
func _physics_process(_delta: float) -> void:
	var direction = player.position - self.position
	var normalized_direction = direction.normalized()
	if self.is_on_wall() or self.is_on_floor() or self.is_on_ceiling():
		queue_free()
	if flipped == 0: 
		if !is_shot:
			velocity = normalized_direction * SPEED
			is_shot = 1
		bullet.flip_v = false
	if flipped == 1: 
		if !is_shot:
			velocity = normalized_direction * SPEED
			is_shot = 1
		bullet.flip_v = true
	move_and_slide()

func _on_life_timeout() -> void:
	queue_free()

func _on_killzone_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	queue_free()
