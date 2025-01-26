extends CharacterBody2D

var speed = 200
var friction = -55
var drag = -0.06

var acceleration = Vector2.ZERO

func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	apply_friction(delta)
	velocity += acceleration * delta
	move_and_slide()

func apply_friction(delta):
	if acceleration == Vector2.ZERO and velocity.length() < 50:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	acceleration += drag_force + friction_force

func get_input():
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
	acceleration = input_vector * speed
