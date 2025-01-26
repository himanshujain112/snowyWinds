extends CharacterBody2D
var health = 3
var speed = 200
var friction = -55
var drag = -0.06
@onready var AnimatedSprite: AnimatedSprite2D = get_node("AnimatedSprite")

var acceleration = Vector2.ZERO

func _ready():
	health = 3
	
func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	apply_friction(delta)
	velocity += acceleration * delta
	changeAnimation()
	clampPosition()
	move_and_slide()

func apply_friction(delta):
	if acceleration == Vector2.ZERO and velocity.length() < 50:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	acceleration += drag_force + friction_force

func get_input():
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
	acceleration = input_vector * speed

	if Input.is_action_just_pressed("ui_select"):
		fireSnowBalls()
		

func changeAnimation():
	if velocity.x < 0:
		$AnimatedSprite.play("rightMove")
	elif velocity.x > 0:
		$AnimatedSprite.play("leftMove")
	else:
		$AnimatedSprite.play("upMove")

func clampPosition():
	position.x = clamp(position.x, 460, get_viewport_rect().size.x - 200)

func fireSnowBalls():
	var snowBall = preload("res://scenes/snowBall.tscn").instantiate()
	get_parent().add_child(snowBall)
	snowBall.position.x = self.position.x
	snowBall.position.y = self.position.y - 20
	await get_tree().create_timer(3).timeout
