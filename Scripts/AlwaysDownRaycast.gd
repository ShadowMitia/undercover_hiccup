extends RayCast2D


func _process(delta: float) -> void:
	set_rot(-get_rot())
