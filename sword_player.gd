extends RigidBody2D


const speed = 200.0
const JUMP_VELOCITY = -350.0
const rotation_speed = 400
const attack_rotation = 120

@onready var rb: RigidBody2D = $"."
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var velocity = Vector2(direction, 0) * speed

	# Add the gravity.
	velocity += get_gravity() * delta

	# Fail-safe check for on death collision logic
	if is_instance_valid(collision_shape):
		# Rotation
		if Input.is_action_pressed("rotate_left"):
			sprite.rotation_degrees += rotation_speed * delta
			#collision_shape.rotation_degrees += rotation_speed * delta
		if Input.is_action_pressed("rotate_right"):
			sprite.rotation_degrees -= rotation_speed * delta
			#collision_shape.rotation_degrees -= rotation_speed * delta
		# Handle jump.
		if Input.is_action_just_pressed("jump"):
			apply_central_impulse(Vector2(0, JUMP_VELOCITY))
		# Sword Swing
		if Input.is_action_just_pressed("attack-deflect"):
			sprite.rotation_degrees += attack_rotation + (rotation_speed/40.0 * delta)
			#collision_shape.rotation_degrees += attack_rotation + (rotation_speed/40.0 * delta)
		# Apply movement
		if direction:
			self.apply_force(velocity, Vector2(0,0))
		else:
			self.apply_force(-velocity, Vector2(0,0))

	if not is_instance_valid(collision_shape):
		self.apply_force(-velocity, Vector2(0,0))
