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
	costExpnt = _costExpnt
	type = upgrades.Enhancement
	pass

func GetCost(shopMul, mul = 1):
	var newMul = 1.1 * ((mul + 1) * 1.1)
	return CalcUpgradeCost(ammount, baseCost, mul, shopMul)

func GetMul():
	return (multiplyer - 100) / 20
	
func UpgradeTrigger():
	multiplyer += 20
