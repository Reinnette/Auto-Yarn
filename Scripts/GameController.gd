extends Node

@onready var shopUpgrades: Node = get_node("../Views/Shop/Control/ListOfUpgrades")
@onready var currencyNode: Node = get_node("../Views/Menu/Header/Currency")
var curencyYarn: LInt = LInt.new()#Shows only to the 100th whole and decimal
var yarn: #Standard Currency
	get:
		return curencyYarn
	
var canEarnSouls = false	
var yarnSoul = 0 #Special Currency
var totSouls = 0
var numNextSoul = 0

var currentBasket = 1 #Used to determin the current basket for the YarnClicker View
var maxBaskets = 1

var lastAutoClick = 0
var goldenBallonCount = 0

func _ready():
	yarn.Add([1])#str(1.00 * (10 ** 7))
	get_node("../Views/Menu/Header/Currency").text = str("Yarn: ", yarn.ToDisplayValue())
	pass

func _process(delta):	
	lastAutoClick += delta
	
	if(lastAutoClick < 1):
		return
		
	lastAutoClick = 0
	var count = 1
	while count <= maxBaskets:
		var upgradeHelper = GetUpgradeHelper(count)
		if(upgradeHelper.HaveAutoClicker()):#No need to process automated values if we are not "auto clicking"
			var yps = upgradeHelper.GetBasketYPS()
			CalcYarnEarned(yps)
		
		count += 1
		pass
	pass
	
func CalcManualClick():	
	var upgradeHelper = GetUpgradeHelper(1)
	var earned = upgradeHelper.cursor[0].GetGenerationAmount()
	
	CalcYarnEarned(earned)
	pass
	
func CalcYarnEarned(earned):
	var upgradeHelper = GetUpgradeHelper(currentBasket)
	var yarnHit = upgradeHelper.modifications[0].ammount + 1
	
	earned[0] *= yarnHit
	
	if(goldenBallonCount > 0):
		earned *= (10 ** goldenBallonCount)
		pass

	yarn.Add(earned)
	CalcSouls(earned)
	shopUpgrades.MulChanged(true)#Live update the Shop Multiplyer
	currencyNode.text = str("Yarn: ", yarn.lint)
	
	upgradeHelper.GenerateNewYarn(yarnHit)
	pass
	
func CalcSouls(earned):
	if numNextSoul <= 0:
		yarnSoul += 1
		numNextSoul = totSouls * (10 ** 10) + numNextSoul
	
	numNextSoul -= earned[0]
	pass
	
func GetUpgradeHelper(basketNum: int):
	return get_node(str("../Baskets/Basket", basketNum))
