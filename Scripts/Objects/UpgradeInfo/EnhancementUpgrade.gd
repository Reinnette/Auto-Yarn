extends Upgrade
class_name EnhancementUpgrade

#Increase item efficiency/Production rate, 
#	1 - Uncommon (Grey)
#	2 - Common (Green)
#	3 - Rare (Blue)
#	4 - Epic (Purple)
#	5 - Legindary (Gold)
#	

var multiplyer: int #How much more the clicker will produce

func _init(_baseCost, _costExpnt):
	baseCost = str(_baseCost)

	for count in _costExpnt:
		baseCost += "0"
	
	type = upgrades.Enhancement
	multiplyer = 100
	pass

func GetCost(shopMul, mul = 1, isDec: bool = false):
	var newMul = 1.1 * ((mul + 1) * 1.1)
	return CalcUpgradeCost(ammount, baseCost, mul, shopMul)

func GetMul():
	return (multiplyer - 100) / 20 + 1
	
func UpgradeTrigger(currentYarn, mul = 1, shopMul = 1):
	var cost = GetCost(shopMul, mul)
	if(!currentYarn.IsGreaterThan(cost)):
		return 0
	
	multiplyer += 20
	cost = GetCost(shopMul, mul)
	upgradeNode.get_node("Cost").text = str(m_i18nNode.GetI81nT("T_Cost"), cost)
	return cost
