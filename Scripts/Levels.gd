extends Node2D


func _ready() -> void:
	var f = File.new()
	var err = f.open("res://Assets/hiccup.ldtk", File.READ)
	var hiccup_ldtk = JSON.parse(f.get_as_text())
	if hiccup_ldtk.error != OK:
		print("Uh oh...")
		return
	
	var guard_scene = load("res://Scenes/Guard.tscn")
	
	for entity in hiccup_ldtk.result["levels"]:
		var level = find_node(entity["identifier"])
		print(level)
		for layer in entity["layerInstances"]:
			for instance in layer["entityInstances"]:
				match instance["__identifier"]:
					"Garde":
						print("Garde")
						var guard = guard_scene.instance()
						var point_path = []
#	
						var px = instance["px"][0]
						var py = instance["px"][1]
						
#						guard.position = level.global_position + Vector2(px, py)
						
						var node = get_tree().get_root()
						node = node.get_node("Root/Guards")
						var path = Path2D.new()
						for point in instance["fieldInstances"][2]["__value"]:
							var x = point["cx"]
							var y = point["cy"]
							path.curve.add_point(level.global_position + Vector2(x * 16, y * 16))
						node.add_child(path)
						
						var path_follow = PathFollow2D.new()
						path.add_child(path_follow)
						path_follow.add_child(guard)
					_:
						print("Pas garde")
