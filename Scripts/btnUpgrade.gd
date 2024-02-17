extends TextureButton

var id = 0
var upgradeType = ""

@onready var rootNode: String = find_parent("MainView").get_path()
@onready var m_gameController: Node = get_node(str(rootNode, "/GameController"))

func _on_pressed():
	var upgradeHelper = m_gameController.GetUpgradeHelper(m_gameController.currentBasket)
	
	if upgradeType == upgradeHelper.clickers[0].type:
		var chosenMul = m_gameController.shopUpgrades.selectedMul
		if id == 0:
			upgradeHelper.cursor[id].UpgradeTrigger(m_gameController, chosenMul, upgradeHelper.multiplyer)
		else:
			upgradeHelper.clickers[id].UpgradeTrigger(m_gameController, chosenMul, upgradeHelper.multiplyer)
	elif upgradeType == upgradeHelper.enhancments[0].type:
		upgradeHelper.enhancments[id].UpgradeTrigger()
	elif upgradeType == upgradeHelper.modifications[0].type:
		upgradeHelper.modifications[id].UpgradeTrigger()
