extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0
var rotation_position = 45
const rotation_speed = 100

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _physics_process(delta: float) -> void:

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")

	# Fail-safe check for on death collision logic
	if is_instance_valid(collision_shape):
		# Rotation
		if Input.is_action_pressed("rotate_left"):
			sprite.rotation_degrees += rotation_speed * delta
			collision_shape.rotation_degrees += rotation_speed * delta
		if Input.is_action_pressed("rotate_right"):
			sprite.rotation_degrees -= rotation_speed * delta
			collision_shape.rotation_degrees -= rotation_speed * delta
		# Apply movement
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	if not is_instance_valid(collision_shape):
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
