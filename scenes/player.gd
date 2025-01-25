extends CharacterBody2D

const MAX_SPEED = 500.0
const ACCELERATION = 200.0
const FRICTION = 50.0
const ROTATION_SPEED = 100.0 # How quickly the car rotates

# Initial velocity
#var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
    var input_vector: Vector2 = Vector2.ZERO

    # Collect input for vertical movement (up/down)
    if Input.is_action_pressed("ui_up"):
        input_vector.y -= 1 # Move up (negative y-direction)
    if Input.is_action_pressed("ui_down"):
        input_vector.y += 1 # Move down (positive y-direction)

    # Collect input for horizontal movement (left/right)
    if Input.is_action_pressed("ui_left"):
        input_vector.x -= 1 # Move left (negative x-direction)
    if Input.is_action_pressed("ui_right"):
        input_vector.x += 1 # Move right (positive x-direction)

    # Normalize input_vector to handle diagonal movement
    input_vector = input_vector.normalized()

    # Apply acceleration to the velocity
    velocity += input_vector * ACCELERATION * delta

    # Apply friction when there's no input
    if input_vector == Vector2.ZERO:
        velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

    # Limit speed to MAX_SPEED
    if velocity.length() > MAX_SPEED:
        velocity = velocity.normalized() * MAX_SPEED

    # Handle rotation based on diagonal movement
    if Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right"):
        # Rotate car 90 degrees anticlockwise for Down + Right
        rotation = deg_to_rad(90) # Rotate to 90 degrees anticlockwise
    elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left"):
        # Rotate car 90 degrees clockwise for Down + Left
        rotation = deg_to_rad(-90) # Rotate to -90 degrees clockwise
    elif Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right"):
        # Rotate car 45 degrees anticlockwise for Up + Right
        rotation = deg_to_rad(45)
    elif Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left"):
        # Rotate car 45 degrees clockwise for Up + Left
        rotation = deg_to_rad(-45)
    else:
        # No diagonal input, reset rotation to 0 (straight direction)
        rotation = 0
    # Move the car using the calculated velocity
    move_and_slide()
