extends RigidBody2D


const speed = 500.0
const JUMP_VELOCITY = -650.0
const rotation_speed = 4
const attack_rotation = 120
const launch = 100
var n = 0
var power = 0

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

func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
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

	# Add the gravity.
	#velocity += get_gravity()

	# Fail-safe check for on death collision logic
	if is_instance_valid(collision_shape):
		# Rotation
		if Input.is_action_pressed("rotate_left"):
			if n == 0:
				if not ray_cast.is_colliding():
					self.rotation_degrees += rotation_speed
					self.angular_velocity = 1
		if Input.is_action_pressed("rotate_right"):
			if n == 0:
				if not ray_cast_3.is_colliding():
					self.rotation_degrees -= rotation_speed
					self.angular_velocity = 1
		# Handle jump.
		if Input.is_action_just_pressed("jump"):
			if ray_cast.is_colliding() or ray_cast_2.is_colliding() or ray_cast_3.is_colliding() or ray_cast_4.is_colliding() or ray_cast_5.is_colliding() or ray_cast_6.is_colliding():
				apply_central_impulse(Vector2(0, JUMP_VELOCITY))
		# Sword Swing
		if Input.is_action_just_pressed("attack-deflect"):
			if n == 0:
				if not (ray_cast.is_colliding() or ray_cast_2.is_colliding() or ray_cast_6.is_colliding()):
					self.rotation_degrees += attack_rotation / 6.0
					self.angular_velocity = 7
					n = 1
		# Lunging Attack
		if Input.is_action_pressed("lunge"):
			if ray_cast.is_colliding() or ray_cast_2.is_colliding() or ray_cast_3.is_colliding() or ray_cast_4.is_colliding() or ray_cast_5.is_colliding() or ray_cast_6.is_colliding():
				look_at(mouse_pos)
				self.rotation_degrees += 90
				if power <= 7:
					if mouse_pos.x > 0:
						self.position.x -= 1
					if mouse_pos.x < 0:
						self.position.x += 1
				power += 1
				if power > 8:
					power = 8
		if Input.is_action_just_released("lunge"):
			apply_central_impulse((Vector2(0, -power*2).rotated(self.rotation))*launch)
			print(mouse_pos)
			power = 0
		# Apply movement
		if direction:
			self.apply_force(velocity, Vector2(0,0))
		else:
			self.apply_force(-velocity, Vector2(0,0))
	#print(mouse_pos)

	if not is_instance_valid(collision_shape):
		self.apply_force(-velocity, Vector2(0,0))
	


func _on_player_kill_body_entered(body: Node2D) -> void:
	if Input.is_action_just_pressed("attack-deflect"):
		if (ray_cast.is_colliding() or ray_cast_7.is_colliding() or ray_cast_8.is_colliding() or ray_cast_9.is_colliding()):
			body.queue_free()
