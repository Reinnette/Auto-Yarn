extends Button

@onready var gameController = find_parent("MainView").get_child(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _pressed():
	gameController.CalcManualClick()
	pass
