extends CharacterBody3D

@export var speed: int = 14
@export var fall_acceleration: int = 75
@export var jump_impulse: int = 20
@export var bounce_impulse: int = 16

var target_velocity: Vector3 = Vector3.ZERO
var can_double_jump: bool = true

func _physics_process(delta: float) -> void:
	var direction: Vector3 = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	if not self.is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	else:
		can_double_jump = true

	self.velocity = target_velocity

	if self.is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	elif can_double_jump and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
		can_double_jump = false

	self.move_and_slide()

	for i in range(self.get_slide_collision_count()):
		var collision: KinematicCollision3D = self.get_slide_collision(i)

		if collision.get_collider() == null:
			continue

		if collision.get_collider().is_in_group("mob"):
			var mob: CharacterBody3D = collision.get_collider()

			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash()
				self.target_velocity.y = self.bounce_impulse
				break
