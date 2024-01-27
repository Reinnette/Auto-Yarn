extends Button


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _pressed():
	var rootNode = find_parent("MainView").get_path()
	get_node(str(rootNode, "/GameController")).CalcYarnEarned(1)
	pass
