extends Area2D

var velocity = Vector2()
var speed = -300
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity.y = speed * delta
	position += velocity

	if position.y < -100:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("snowman"):
		body.health -= 1
		self.queue_free()