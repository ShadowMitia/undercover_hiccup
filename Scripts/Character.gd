extends KinematicBody2D

var velocity := Vector2.ZERO
const SPEED := 100.0


func _input(event: InputEvent) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	move_and_slide(dir * SPEED)

	rotation = dir.angle()
	
	
