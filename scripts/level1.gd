extends Node

var snowman = 3
func _process(_delta: float) -> void:
	if snowman <= 0:
		print("Level Completed")
		get_tree().change_scene("control.tscn")