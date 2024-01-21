extends Button


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _pressed():
	get_node("../../../GameController").CalcYarnEarned(1)
	pass
