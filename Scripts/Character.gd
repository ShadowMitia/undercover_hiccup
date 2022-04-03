extends KinematicBody2D

var velocity := Vector2.ZERO
const SPEED := 100.0

onready var camera := $Camera2D


var shake_amount = 1000

var hiccup_shake = false

func _input(event: InputEvent) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	move_and_slide(dir * SPEED)

	rotation = dir.angle()
	
	if hiccup_shake:
		camera.set_offset(lerp(camera.get_offset(), Vector2.ZERO, 0.1))



func _on_TimerHiccup_timeout() -> void:
	print("Hiccup!")
	$RandomHiccupsPlayer.play()
	hiccup_shake = true
	$HiccupShakeTimer.start()
	camera.set_offset(Vector2(rand_range(-1.0, 1.0), -20.0))

func _on_HiccupShakeTimer_timeout() -> void:
	hiccup_shake = false
	camera.set_offset(Vector2.ZERO)
