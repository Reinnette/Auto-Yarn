extends UpgradeData
class_name Upgrade

enum upgrades {Clickers, Enhancement, Mods}

@onready var m_i18nNode: Node

func Connect(refreshSignal, i18nNode):
	refreshSignal.connect(NodeRefrech)
	m_i18nNode = i18nNode

func GetCost(shopMul, mul = 1, isDec = false):
	var amnt = GetAmount() if !isDec else GetAmount() - 1
	return CalcUpgradeCost(amnt, str(baseCost), mul, shopMul)

func GetAmount():
	return ammount
	
func IncAmount(mul = 1):	
	ammount += 1 * mul

func DecAmount(shopMul: int, selectedMul: int, currentYarn: LInt):
	ammount -= 1 * GetMultiplyer(shopMul, selectedMul, currentYarn)
	
	var cost = GetCost(shopMul, GetMultiplyer(shopMul, selectedMul, currentYarn), true)
	UpdateText(cost, currentYarn)
	return cost

func UpgradeTrigger(gameController: Node, selectedMul: int = 1, shopMul: int = 1):
	var cost: Array
	
	if isSell[0]:
		if ammount <= 0:
			return 0
		cost = GetCost(shopMul, GetMultiplyer(shopMul, selectedMul, gameController.yarn), true)
		gameController.yarn.Add(cost)
		
		cost = DecAmount(shopMul, selectedMul, gameController.yarn)
	else:
		if(!gameController.yarn.IsGreaterThan(cost)):
			return 0
		cost = GetCost(shopMul, GetMultiplyer(shopMul, selectedMul, gameController.yarn))
		gameController.yarn.Minus(cost)
		
		IncAmount(selectedMul)
		cost = GetCost(shopMul, GetMultiplyer(shopMul, selectedMul, gameController.yarn))
	UpdateText(cost, gameController.yarn)
	gameController.currencyNode.text = str("Yarn: ", gameController.yarn.lint)
	
func NodeRefrech(currentYarn: LInt, shopMul: int, selectedMul: int):
	var cost: Array 
	if !isSell[0]:
		cost = GetCost(shopMul, GetMultiplyer(shopMul, selectedMul, currentYarn))
	else:
		cost = GetCost(shopMul, GetMultiplyer(shopMul, selectedMul, currentYarn), true)
	
	UpdateText(cost, currentYarn)
	pass
	

func UpdateText(cost: Array, currentYarn: LInt):
	var lint = LInt.new()
	lint.lint = lint.ConvertToString(cost)
	var displayCost: String = lint.ToDisplayValue()
	var isDisabled = !currentYarn.IsGreaterThan(lint.ConvertToInts())
	
	var btnNode: Node = upgradeNode.get_node("Upgrade")
	var costNode: Node = btnNode.get_node("Cost")

	costNode.text = str(m_i18nNode.GetI81nT("T_Cost"), displayCost)
	btnNode.disabled = isDisabled
#region Helper Functions

func CalcUpgradeCost(ammount, cost, mul, shopMul):
	var yarnCost: LInt = LInt.new()
	yarnCost.lint = cost
	
	yarnCost.Mul(ammount+1 * 1.15)
	yarnCost.Mul(1.15)
	yarnCost.Mul(mul)
	yarnCost.Mul(shopMul)
	
	return yarnCost.ConvertToInts()
	
func GetMultiplyer(shopMul: int, selectedMul: int, currentYarn: LInt):
	#If the multiplyer is set to Max then get the max Multiplyer that 
		#	can be afforded for this node
	if(selectedMul == 999):
		var cost: Array = GetCost(shopMul, 1)
		return currentYarn.Divide(cost)
		
	return selectedMul
	pass

#endregion Helper Functions
