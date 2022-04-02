extends KinematicBody2D

var velocity := Vector2.ZERO
const SPEED := 100.0


func _input(event: InputEvent) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	move_and_slide(dir * SPEED)

	rotation = dir.angle()
	
	$Camera2D.rotation = lerp($Camera2D.rotation, 0, 0.001)
	


func _on_TimerHiccup_timeout() -> void:
	print("Hiccup!")
	$RandomHiccupsPlayer.play()
	$Camera2D.rotation = -2
	
