extends KinematicBody2D

const SPEED:=100.0

onready var player:KinematicBody2D = get_tree().get_nodes_in_group("player")[0]

export(NodePath) var path_path:NodePath
var path:Path2D
var path_follow:PathFollow2D

var reversed := false

const SPEED_MAX := 20.0

var _acceleration := 1000.0
var _speed := 0.0

var prev_pos := Vector2.ZERO

var follow_player := false
var steering_player := Vector2.ZERO

var hiccup_look := false

var old_rotation := 0.0

var hiccup_distance := 400.0

func resume_walk() -> void:
	hiccup_look = false

func on_player_hiccuped(position:Vector2) -> void:
	var diff = position - $RayCast2D.global_position
	if diff.length() > hiccup_distance:
		return
	old_rotation = rotation
	rotation = diff.normalized().dot(Vector2.DOWN)
	hiccup_look = true

	get_tree().create_timer(3.0).connect("timeout", self, "resume_walk")

func _ready() -> void:
	path = get_node("../../")
	print(path)
	path_follow = get_node("..")
	print(path_follow)

	player.connect("hiccuped", self, "on_player_hiccuped")
	


func _physics_process(delta: float) -> void:
	$RayCast2D.rotation = -global_rotation
	var diff = player.position - $RayCast2D.global_position
	$RayCast2D.cast_to = diff

	if diff.length() > hiccup_distance:
		if follow_player:
			follow_player = false
			rotation = old_rotation
		return

	if not follow_player and $RayCast2D.is_colliding() and $RayCast2D.get_collider() == player:
		follow_player = true
		old_rotation = rotation
	elif follow_player and ((not $RayCast2D.is_colliding()) or $RayCast2D.get_collider() != player):
		follow_player = false
		rotation = lerp_angle(rotation, old_rotation, 0.1)
	elif not hiccup_look and not follow_player:
		rotation = lerp_angle(rotation, old_rotation, 0.1)
		
	if follow_player:
		hiccup_look = false
		rotation = lerp_angle(rotation, diff.normalized().dot(Vector2.DOWN), 0.01)

func _process(delta: float) -> void:
	
	if path and not follow_player and not hiccup_look:
		$AnimatedSprite.play("walking")
		_speed = SPEED_MAX * delta

		if not reversed:
			path_follow.offset += _speed
			$AnimatedSprite.flip_h = false
		else:
			path_follow.offset -= _speed
			$AnimatedSprite.flip_h = true
			
		if path_follow.offset >= path.curve.get_baked_length():
			reversed = not reversed
		elif path_follow.offset <= 0:
			reversed = not reversed
	else:
		$AnimatedSprite.play("idle")
