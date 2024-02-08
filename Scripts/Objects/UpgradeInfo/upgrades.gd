extends UpgradeData
class_name Upgrade

enum upgrades {Clickers, Enhancement, Mods}

func GetCost(shopMul, mul = 1):
	return CalcUpgradeCost(GetAmount(), baseCost, mul, shopMul)

func GetAmount():
	return ammount
	
func IncAmount(mul = 1):
	ammount += 1 * mul

func DecAmount(mul = 1):
	ammount -= 1 * mul

func UpgradeTrigger():
	IncAmount()

#region Helper Functions

func CalcUpgradeCost(ammount, cost, mul, shopMul):
	var yarnCost: LInt = LInt.new()
	yarnCost.lint = cost
	
	yarnCost.Mul(ammount+1 * 1.15)
	yarnCost.Mul(1.15)
	yarnCost.Mul(mul)
	yarnCost.Mul(shopMul)
	
	return yarnCost.ConvertToInts()

#endregion Helper Functions
