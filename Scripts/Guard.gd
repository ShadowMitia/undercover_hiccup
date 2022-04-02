extends KinematicBody2D

const SPEED:=100.0

var player:=KinematicBody2D

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

var old_rotation := 0.0

func _ready() -> void:
	path = get_node(path_path)
	if path:
		path_follow = path.get_node("PathFollow2D")

	player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta: float) -> void:
	$RayCast2D.rotation = -global_rotation
	var diff = player.position - $RayCast2D.global_position
	$RayCast2D.cast_to = diff
	
	if diff.length() > 400:
		if follow_player:
			follow_player = false
			rotation = old_rotation
		return

	if not follow_player and $RayCast2D.is_colliding() and $RayCast2D.get_collider() == player:
		follow_player = true
		old_rotation = rotation
	elif follow_player and ((not $RayCast2D.is_colliding()) or $RayCast2D.get_collider() != player):
		follow_player = false
		rotation = old_rotation

	if follow_player:
		rotation = lerp_angle(rotation, diff.normalized().dot(Vector2.DOWN), 0.01)

func _process(delta: float) -> void:
	
	if path and not follow_player:
		_speed = SPEED_MAX * delta

		if not reversed:
			path_follow.offset += _speed
			$Sprite.flip_h = false
		else:
			path_follow.offset -= _speed
			$Sprite.flip_h = true
			
		if path_follow.offset >= path.curve.get_baked_length():
			reversed = not reversed
		elif path_follow.offset <= 0:
			reversed = not reversed
