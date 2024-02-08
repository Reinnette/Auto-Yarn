extends Node

var curencyYarn: LInt = LInt.new()#Shows only to the 100th whole and decimal
var yarn: #Standard Currency
	get:
		return curencyYarn
	set(value): 
		curencyYarn.lint = value
		
var yarnSoul = 0 #Special Currency
var currentBasket = 1 #Used to determin the current basket for the YarnClicker View
var maxBaskets = 1

var lastAutoClick = 0
var goldenBallonCount = 0

func _ready():
	#yarn = str(1.00 * (10 ** 63))
	pass

func _process(delta):	
	lastAutoClick += delta
	
	if(lastAutoClick < 1):
		return
		
	var shopUpgrades = get_node("../Views/Shop/Control/ListOfUpgrades")
	shopUpgrades.MulChanged(true)#Live update the Shop Multiplyer
		
	lastAutoClick = 0
	var count = 1
	while count <= maxBaskets:
		var upgradeHelper = get_node(str("../Baskets/Basket", count))
		if(upgradeHelper.HaveAutoClicker()):#No need to process automated values if we are not "auto clicking"
			var yps = upgradeHelper.GetBasketYPS()
			CalcYarnEarned(yps)
		
		count += 1
		pass
	pass
	
func CalcManualClick():	
	var upgradeHelper = get_node(str("../Baskets/Basket", 1))
	var earned = upgradeHelper.cursor.GetGenerationAmount()
	
	CalcYarnEarned(earned)
	pass
	
func CalcYarnEarned(earned):
	var yarnHit = 1#(upgradeHelper.multiStrikeLevel + 1
	
	earned *= yarnHit
	
	if(goldenBallonCount > 0):
		earned *= (10 ** goldenBallonCount)
		pass
	
	var listEarned = [earned]
	
	yarn.Add(listEarned)
	get_node("../Views/Menu/Header/Currency").text = str("Yarn: ", yarn.lint)
	
	YarnPopped(yarnHit)
	pass

func YarnPopped(yarnHit):
	var upgradeHelper = get_node(str("../Baskets/Basket", currentBasket))
	
	#change the on screen yarn
	var alreadyPopped = []
	
	for count in yarnHit:
		var rng = GetRandNum(yarnHit)
		 
		while(upgradeHelper.yarnInBasket.has(rng)):
			rng = GetRandNum(yarnHit)
			
		alreadyPopped.append(rng)
		
		upgradeHelper.yarnInBasket[rng-1] -= 1
		
		pass
	pass
	
	pass
	
func GetRandNum(max):
	return RandomNumberGenerator.new().randi_range(0, max)
	
func test(number):
	# how many places to move the zero.
	var _exp = str(number).split(".")[0].length() - 1

	# divide with same magnitude
	var _dec = number / pow(10,_exp)

	# print only what we want, add exp
	print("{dec}e{exp}".format({"dec":("%1.2f" % _dec), "exp":str(_exp) }) )
