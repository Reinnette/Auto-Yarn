extends Button

var id = 0
var upgradeType = ""

func _on_pressed():
	get_node("../../../../").UpgradeButtonPressed(id, upgradeType)
	pass
