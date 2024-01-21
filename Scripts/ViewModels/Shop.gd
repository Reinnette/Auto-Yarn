extends Button

var upgradesShown = false
func _pressed():
	
	var views = get_node("../../../")
	print(views.name)
	var upgrade = views.get_node("Shop/Control/ListOfUpgrades")
	
	
	if !upgradesShown:
		upgrade.LoadShop()
		views.get_node("Shop").visible = true
		upgradesShown = true
	else:
		views.get_node("Shop").visible = false
		upgradesShown = false
	
	pass
