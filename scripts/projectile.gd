extends CharacterBody2D

@export var SPEED = 80
@onready var ray_cast: RayCast2D = $LeftRays/RayCast2D
@onready var ray_cast_2: RayCast2D = $LeftRays/RayCast2D2
@onready var ray_cast_4: RayCast2D = $LeftRays/RayCast2D4
@onready var ray_cast_5: RayCast2D = $LeftRays/RayCast2D5
@onready var ray_cast_3: RayCast2D = $LeftRays/RayCast2D3
@onready var ray_cast_6: RayCast2D = $RightRays/RayCast2D6
@onready var ray_cast_7: RayCast2D = $RightRays/RayCast2D7
@onready var ray_cast_8: RayCast2D = $RightRays/RayCast2D8
@onready var ray_cast_9: RayCast2D = $RightRays/RayCast2D9
@onready var ray_cast_10: RayCast2D = $RightRays/RayCast2D10

var dir : float
var spawnPos : Vector2
var spawnRot : float

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	
func _physics_process(_delta: float) -> void:
	if self.is_on_wall():
		queue_free()
	velocity = Vector2(-SPEED,0).rotated(dir)
	move_and_slide()

func _on_life_timeout() -> void:
	queue_free()

func _on_killzone_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	print("test")
	queue_free()
