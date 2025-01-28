extends CharacterBody2D

@export var SPEED = 80

var dir : float
var spawnPos : Vector2
var spawnRot : float

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	
func _physics_process(_delta: float) -> void:
	velocity = Vector2(-SPEED,0).rotated(dir)
	move_and_slide()
	
func _on_area_2d_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	print("hit")
	queue_free()

func _on_life_timeout() -> void:
	print("time out")
	queue_free()
