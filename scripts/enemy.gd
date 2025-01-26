extends RigidBody2D

@export var speed = 200.0 # Speed of the car
@export var stop_threshold = 5.0 # Distance to stop when close to a target
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var checkPointIndex = -1 # -1 indicates the starting point
var map_ready = false
var has_reached_start = false # To track if the car has already reached the start point

func _ready() -> void:
    navigation_agent_2d.connect("navigation_finished", Callable(self, "_on_navigation_finished"))
    NavigationServer2D.map_changed.connect(_on_map_changed)
    print("AI Ready: Navigation setup complete.")

func _physics_process(_delta: float) -> void:
    if not map_ready:
        return

    if navigation_agent_2d.is_navigation_finished():
        _set_new_target()
    else:
        _move_towards_target()

func _move_towards_target() -> void:
    var next_path_position = navigation_agent_2d.get_next_path_position()
    if next_path_position != Vector2.ZERO:
        var distance_to_target = global_position.distance_to(next_path_position)
        if distance_to_target <= stop_threshold:
            linear_velocity = Vector2.ZERO
            print("Close enough to target. Stopping movement.")
            navigation_agent_2d.advance_path()
            return

        var velocity = global_position.direction_to(next_path_position) * speed
        linear_velocity = velocity
        look_at(global_position + velocity)
        print("Moving to: ", next_path_position, " Current Velocity: ", velocity)

func _set_new_target() -> void:
    var checkPoints = get_tree().get_nodes_in_group("checkPoint")
    
    if checkPointIndex == -1:
        # First move to the start point
        var start_point = get_tree().get_first_node_in_group("startPoint")
        if start_point:
            navigation_agent_2d.target_position = start_point.global_position
            print("Moving to start point: ", start_point.global_position)
            has_reached_start = true
        else:
            print("Error: No start point found.")
        return

    if checkPointIndex < checkPoints.size():
        # Move to the next checkpoint
        var checkpoint = checkPoints[checkPointIndex]
        if checkpoint and checkpoint.has_method("global_position"):
            navigation_agent_2d.target_position = checkpoint.global_position
            print("Setting new target (Checkpoint): ", checkpoint.global_position)
        checkPointIndex += 1
    else:
        # Once all checkpoints are reached, stop at the last checkpoint and don't return to start
        if has_reached_start:
            checkPointIndex = -1 # Reset for the next loop if needed.
            print("Finished all checkpoints. No more target to set.")
        else:
            # Return to the start point after completing all checkpoints
            var start_point = get_tree().get_first_node_in_group("startPoint")
            if start_point:
                navigation_agent_2d.target_position = start_point.global_position
                print("Returning to start point: ", start_point.global_position)
            has_reached_start = true

func _on_navigation_finished():
    print("Target reached. Setting new target.")
    _set_new_target()

func _on_map_changed(map_id):
    print("Navigation map synchronized. Ready for movement.")
    map_ready = true
    _set_new_target()
