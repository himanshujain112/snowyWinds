extends RigidBody2D

var health = 3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if health <= 0:
		queue_free()