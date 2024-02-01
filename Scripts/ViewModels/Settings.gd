extends Button


func _pressed():
	var allMenuButtons = get_parent().get_children()
	for menuButton in allMenuButtons:
		menuButton.disabled = false
		
	disabled = true
	var views = get_node("../../../")
	
	views.get_node("YarnClicker").visible = false
	views.get_node("Shop").visible = false
	views.get_node("Settings").visible = true	
	
	pass
