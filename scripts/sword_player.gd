extends RigidBody2D


const speed = 500.0
const JUMP_VELOCITY = -650.0
const rotation_speed = 5
const attack_rotation = 120
const launch = 100
var n = 0
var power = 0
var is_lunging = 0
var lunge_direction = Vector2.ZERO
var previous_pos = Vector2.ZERO
var timer_expired = 0
var is_stuck = 0
var is_charging = 0

@onready var rb: RigidBody2D = $"."
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var ray_cast: RayCast2D = $RayCasts/RayCast2D
@onready var ray_cast_2: RayCast2D = $RayCasts/RayCast2D2
@onready var ray_cast_3: RayCast2D = $RayCasts/RayCast2D3
@onready var ray_cast_4: RayCast2D = $RayCasts/RayCast2D4
@onready var ray_cast_5: RayCast2D = $RayCasts/RayCast2D5
@onready var ray_cast_6: RayCast2D = $RayCasts/RayCast2D6
@onready var camera: Camera2D = $Camera2D
@onready var ray_cast_7: RayCast2D = $RayCasts/RayCast2D7
@onready var ray_cast_8: RayCast2D = $RayCasts/RayCast2D8
@onready var ray_cast_9: RayCast2D = $RayCasts/RayCast2D9
@onready var pig: Node2D = $"."
@onready var ray_cast_10: RayCast2D = $RayCasts/RayCast2D10
@onready var ray_cast_11: RayCast2D = $RayCasts/RayCast2D11
@onready var ray_cast_12: RayCast2D = $RayCasts/RayCast2D12
@onready var ray_cast_13: RayCast2D = $RayCasts/RayCast2D13
@onready var ray_cast_14: RayCast2D = $RayCasts/RayCast2D14
@onready var timer: Timer = $Timer
@onready var moving_particles: GPUParticles2D = $MovingParticles

func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction = 0
	if is_stuck == 0:
		direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var velocity = Vector2(direction, 0) * speed
	var mouse_pos = get_global_mouse_position()

	match n:
		1:
			if not (ray_cast.is_colliding() or ray_cast_2.is_colliding() or ray_cast_6.is_colliding()):
				self.rotation_degrees += attack_rotation / 6.0
			n = 2
		2:
			if not (ray_cast.is_colliding() or ray_cast_2.is_colliding() or ray_cast_6.is_colliding()):
				self.rotation_degrees += attack_rotation / 6.0
			n = 3
		3:
			if not (ray_cast.is_colliding() or ray_cast_2.is_colliding() or ray_cast_6.is_colliding()):
				self.rotation_degrees += attack_rotation / 6.0
			n = 4
		4:
			if not (ray_cast.is_colliding() or ray_cast_2.is_colliding() or ray_cast_6.is_colliding()):
				self.rotation_degrees += attack_rotation / 6.0
			n = 5
		5:
			if not (ray_cast.is_colliding() or ray_cast_2.is_colliding() or ray_cast_6.is_colliding()):
				self.rotation_degrees += attack_rotation / 6.0
			n = 6
		6:
			if not (ray_cast.is_colliding() or ray_cast_2.is_colliding() or ray_cast_6.is_colliding()):
				self.rotation_degrees += attack_rotation / 6.0
			n = 0
			moving_particles.amount = 8
			moving_particles.emitting = false

	# Fail-safe check for on death collision logic
	if is_instance_valid(collision_shape):
		# Rotation
		if Input.is_action_pressed("rotate_left") and is_stuck == 0:
			self.freeze = false
			moving_particles.emitting = false
			self.gravity_scale = 1
			if n == 0:
				if not ray_cast.is_colliding():
					self.rotation_degrees += rotation_speed
					self.angular_velocity = 2
		if Input.is_action_pressed("rotate_right") and is_stuck == 0:
			self.freeze = false
			moving_particles.emitting = false
			self.gravity_scale = 1
			if n == 0:
				if not ray_cast_3.is_colliding():
					self.rotation_degrees -= rotation_speed
					self.angular_velocity = 2


		# Handle jump.
		if Input.is_action_just_pressed("jump"):
			reset_position()
			self.freeze = false
			self.gravity_scale = 1
			if (ray_cast.is_colliding() or ray_cast_2.is_colliding() or ray_cast_3.is_colliding() or ray_cast_4.is_colliding() or ray_cast_5.is_colliding() or ray_cast_6.is_colliding()) and is_stuck != 1:
				apply_central_impulse(Vector2(0, JUMP_VELOCITY))
			is_stuck = 0
			moving_particles.emitting = false


		# Sword Swing
		if Input.is_action_just_pressed("attack-deflect") and is_stuck == 0:
			if n == 0:
				moving_particles.emitting = true
				moving_particles.amount_ratio = 4
				if not (ray_cast.is_colliding() or ray_cast_2.is_colliding() or ray_cast_6.is_colliding()):
					self.rotation_degrees += attack_rotation / 6.0
					self.angular_velocity = 7
					n = 1


		# Lunging Attack
		# Charging
		if Input.is_action_pressed("lunge"):
			if is_stuck == 1: reset_position()
			if ray_cast.is_colliding() or ray_cast_2.is_colliding() or ray_cast_3.is_colliding() or ray_cast_4.is_colliding() or ray_cast_5.is_colliding() or ray_cast_6.is_colliding() or is_stuck == 1 or is_charging == 1:
				is_charging = 1
				is_stuck = 0
				moving_particles.emitting = false
				self.apply_force(Vector2(0,0), Vector2(0,0))
				look_at(mouse_pos)
				self.rotation_degrees += 90
				if power <= 7: sprite.position.y += 2
				power += 1
				if power > 8: power = 8
		# Releasing attack
		if Input.is_action_just_released("lunge"):
			self.freeze = false
			self.gravity_scale = 1
			moving_particles.emitting = true
			if not (ray_cast.is_colliding() or ray_cast_2.is_colliding() or ray_cast_3.is_colliding() or ray_cast_4.is_colliding() or ray_cast_5.is_colliding() or ray_cast_6.is_colliding() or ray_cast_7.is_colliding() or ray_cast_8.is_colliding() or ray_cast_9.is_colliding() or ray_cast_10.is_colliding() or ray_cast_11.is_colliding()):
				moving_particles.emitting = false
			is_lunging = 1
			is_charging = 0
			if is_lunging == 0 and is_stuck == 0: sprite.position.y -= 16
			apply_central_impulse((Vector2(0, -power*1.25).rotated(self.rotation))*launch)
			lunge_direction = self.position - previous_pos
			power = 0
			timer.start()
		# Checking if stab would stick sword in
		if (ray_cast_2.is_colliding() or ray_cast_13.is_colliding() or ray_cast_14.is_colliding()) and is_lunging == 1 and timer_expired == 1:
			self.linear_velocity = Vector2.ZERO
			self.angular_velocity = 0
			self.gravity_scale = 0
			sprite.position.y -= 14
			is_lunging = 0
			timer_expired = 0
			is_stuck = 1
			moving_particles.emitting = false
		# Check if stab doesnt stick
		if (ray_cast.is_colliding() or ray_cast_3.is_colliding() or ray_cast_4.is_colliding() or ray_cast_5.is_colliding() or ray_cast_6.is_colliding() or ray_cast_7.is_colliding() or ray_cast_8.is_colliding() or ray_cast_9.is_colliding() or ray_cast_10.is_colliding() or ray_cast_11.is_colliding() or ray_cast_12.is_colliding()) and is_lunging == 1 and timer_expired == 1:
			self.freeze = false
			self.gravity_scale = 1
			is_lunging = 0
			moving_particles.emitting = false
			timer_expired = 0


		# Apply movement
		if direction: self.apply_force(velocity, Vector2(0,0))
		else: self.apply_force(-velocity, Vector2(0,0))

	# On death mechanics
	if not is_instance_valid(collision_shape):
		self.apply_force(-velocity, Vector2(0,0))
	
	previous_pos = self.position
	#print("is stuck")
	#print(is_stuck)
	#print("is lunging")
	#print(is_lunging)

func _on_player_kill_body_entered(body: Node2D) -> void:
	if Input.is_action_just_pressed("attack-deflect"):
		if (ray_cast.is_colliding() or ray_cast_7.is_colliding() or ray_cast_8.is_colliding() or ray_cast_9.is_colliding()):
			body.queue_free()


func _on_timer_timeout() -> void:
	timer_expired = 1
	reset_position()

func reset_position():
	var sword_node = get_node("Sprite2D")
	sword_node.position = Vector2(0, 0)
