extends KinematicBody2D

var velocity := Vector2.ZERO
const SPEED := 100.0

onready var camera := $Camera2D

signal hiccuped(position)

var shake_amount = 1000

var hiccup_shake = false

var hiccup_mode := false

func _physics_process(delta: float) -> void:
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	move_and_slide(dir * SPEED)

	if dir.length() > 0 or dir.length() < 0:
		rotation = dir.angle()
		$AnimatedSprite.play("walking")
	else:
		$AnimatedSprite.play("idle")
		
		
	if not hiccup_mode:
		return
	
	if hiccup_shake:
		camera.set_offset(lerp(camera.get_offset(), Vector2.ZERO, 0.1))



func _on_TimerHiccup_timeout() -> void:
	print("Hiccup!")
	$RandomHiccupsPlayer.play()
	hiccup_shake = true
	$HiccupShakeTimer.start()
	camera.set_offset(Vector2(rand_range(-1.0, 1.0), -80.0))
	
	emit_signal("hiccuped", position)

func _on_HiccupShakeTimer_timeout() -> void:
	hiccup_shake = false
	camera.set_offset(Vector2.ZERO)


func _on_HiccupStart_body_entered(body: Node) -> void:
	if body == self and not hiccup_mode:
		hiccup_mode = true
		$TimerHiccup.start()
