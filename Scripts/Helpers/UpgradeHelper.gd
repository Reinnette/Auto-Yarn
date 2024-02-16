extends Node

var multiplyer = 1
var yarnInBasket = [1]#The Yarn on screen and the level of the yarn

var cursor = [ClickerUpgrade.new(10, 		0, 	1,	0) #Hand
	]
var clickers = [
	ClickerUpgrade.new(12, 		0, 	0.1,	0), #Hand
	ClickerUpgrade.new(80, 		0, 	1, 		0), #Needles
	ClickerUpgrade.new(1080, 	0, 	8, 		0), #Kittens
	ClickerUpgrade.new(12, 		3, 	47, 	0), #Yarn Farm
	ClickerUpgrade.new(13, 		4, 	260, 	0), #Mamma Cat
	ClickerUpgrade.new(14, 		5, 	1400, 	0), #Scissors
	ClickerUpgrade.new(2, 		7, 	7800, 	0), #Bank of Yarn
	ClickerUpgrade.new(33, 		7, 	44, 	3), #Baby Dragon
	ClickerUpgrade.new(51, 		8, 	260, 	3), #Research Center
	ClickerUpgrade.new(75, 		9, 	16, 	5), #Shredder
	ClickerUpgrade.new(1, 		12, 10, 	6), #Loom
	ClickerUpgrade.new(14, 		12, 65, 	6), #Toxic Brew
	ClickerUpgrade.new(170, 	12, 430, 	6), #Milk Factory
	ClickerUpgrade.new(21, 		14, 29, 	8), #Kitten Temple
	ClickerUpgrade.new(26, 		15, 21, 	9), #Anti-Mater
	ClickerUpgrade.new(310, 	15, 150, 	9), #Time Bomb
	ClickerUpgrade.new(71, 		18, 11, 	11), #Atom-Spliter
	ClickerUpgrade.new(12, 		21, 83, 	11), #Black-Cat Luck
	ClickerUpgrade.new(19, 		21, 64, 	12), #Comet Storm
	ClickerUpgrade.new(540, 	21, 540, 	12) #Black Hole
	]
var enhancments = []
var modifications = [
	ModsUpgrade.new(40, 	6, Callable(RunMultiYarn)),#Multi-Yarn
	ModsUpgrade.new(400, 	6, Callable(RunGoldenYarn)),#Golden Yarn
	ModsUpgrade.new(9999, 	6, Callable(RunYarnatonic)),#Yarnatonic
	ModsUpgrade.new(60, 	6, Callable(RunMulBasketUpgrade)),#Multi-Basket
	ModsUpgrade.new(9999, 	6, Callable(RunYarnEvolution))#Yarn Evolution #Need to have gotten X yarn. Perstege points are yarn / X
	]

func _init():
	for count in clickers.size():
		enhancments.append(EnhancementUpgrade.new(clickers[count].baseCost, clickers[count].costExpnt))

#region Modifications
	
#Multi Basket - Adds another basket to unravel Yarn in 
#Note: cost of the upgrades in the new basket you go up by 10x but also reward 7x more
func RunMulBasketUpgrade():
	#clickers.remove_at(index)
	var basketNode = self.duplicate()
	basketNode.name = str("Basket", modifications[3].ammount+2)
	
	#The first basket should be the only one to upgrade the Hand Clicker, 
	#	Multi Basket, and Yarn Evolution
	basketNode.clickers.remove_at(0)
	basketNode.modifications.remove_at(3)
	basketNode.modifications.remove_at(4)
	
	get_parent().add_child(basketNode)
	pass

#Multi Yarn - adds another yarn to unravel
func RunMultiYarn():
	#Set to the current Yarnatonic amount
	yarnInBasket.append(modifications[2].ammount)
	pass
	
#Golden Yarn - every X layers will be golden varient giving 10x 
func RunGoldenYarn():
	pass
	
#Yarntonic - special potion that makes the Yarn stronger advancing it by X Layers
func RunYarnatonic():
	pass
	
#Yarn Evolution - Reset your current standing where Yarn is stronger(+10%) and gain X special points
func RunYarnEvolution():
	#Oh boy here we go....
	#Time to spiral into madness
	
	var gameController = find_parent("MainView").get_child(2)
	gameController.yarn = "0"
	gameController.canEarnSouls = true
	gameController.yarnSouls += (modifications[4].ammount+1) * 1000
	pass

#endregion Modifications


#region Helper Functions

func GetUpgradeCost(index, type, mul = 1):
	if type == clickers[0].type:
		return cursor[0].GetCost(multiplyer, mul) if index == 0 else clickers[index-1].GetCost(multiplyer, mul)
	elif type == enhancments[0].type:
		var baseCost = enhancments[index].GetCost(multiplyer)
		var cost = LInt.new()
		cost.lint = cost.ConvertToString(baseCost)
		cost.Mul(1.25 * 1.25)
		return cost.ConvertToInts()
	elif type == modifications[0].type:
		return modifications[index].GetCost(multiplyer)


func HaveAutoClicker():
	var hasAuto = false
	
	for index in range(0,clickers.size()):
		var clickerInfo = clickers[index]
		
		if(hasAuto):
			continue
			
		if(clickerInfo.ammount > 0):
			hasAuto = true
			
		pass
		
	return hasAuto
	pass
	
	
func GetBasketYPS():#Gets this baskets yarn per second(YPS)
	var basketYPS = LInt.new()
	
	#Run through all the clickers and calculate the YPS
	for index in clickers.size():
		#No need to continue if the clicker has not been purchased
		if(clickers[index].ammount == 0):
			continue

		var clickerYPS = clickers[index].GetGenerationAmount(enhancments[index].GetMul())
		
		#Earn an additinal 1% per evolution level
		if modifications[4].ammount != null && modifications[4].ammount > 0:
			clickerYPS *= (modifications[4].ammount * 1.1)
		
		basketYPS.lint = basketYPS.ConvertToString(clickerYPS)
		pass
	
	return basketYPS.ConvertToInts()
	pass
	

#Randomized the yarn in the Basket
func GenerateNewYarn(ammount):
	for count in yarnInBasket.size():
		var goldenYarnAmmount = modifications[2].ammount
		var newVal = RandomNumberGenerator.new().randi_range(1, goldenYarnAmmount)
		
		#Check if a golden ballon
		var chance = goldenYarnAmmount * 10 - (yarnInBasket.count("99") * 75)
		var rand = RandomNumberGenerator.new().randi_range(1, 100)
		
		if(rand <= chance):
			newVal = "99"
		
		yarnInBasket[count] = newVal
		pass
	pass
#endregion Helper Functions
