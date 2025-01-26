extends RigidBody2D

@export var speed = 2

@onready var car: Node2D = $Car
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var checkPointIndex = 0

func _ready() -> void:
	car.top_level = true

func _physics_process(_delta: float) -> void:
	if not navigation_agent_2d.target_position: _set_new_target()
	
	var next_path_position: Vector2 = navigation_agent_2d.get_next_path_position()
	
	var velocity = global_position.direction_to(next_path_position) * speed
	
	linear_velocity = velocity
	
	car.global_position = global_position - Vector2(0, 0)
	car.look_at(global_position - velocity)

func _set_new_target():
	var checkPoints = get_tree().get_nodes_in_group("checkPoints")
	if checkPoints.size() == checkPointIndex:
		navigation_agent_2d.target_position = get_tree().get_first_node_in_group("startPoint").global_position
		checkPointIndex = 0
	else:
		navigation_agent_2d.target_position = get_tree().get_nodes_in_group("checkPoints")[checkPointIndex].global_position
		checkPointIndex += 1

func _on_navigation_agent_2d_navigation_finished() -> void:
	_set_new_target()
