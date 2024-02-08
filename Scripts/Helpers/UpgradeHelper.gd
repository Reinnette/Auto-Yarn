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

#Multi Yarn - adds another yarn to unravel
#Golden Yarn - every X layers will be golden varient giving 10x 
#Yarntonic - special potion that makes the Yarn stronger advancing it by X Layers
#Yarn Evolution - Reset your current standing where Yarn is stronger(+10%) and gain X special points
	
#Multi Basket - Adds another basket to unravel Yarn in 
#Note: cost of the upgrades in the new basket you go up by 10x but also reward 7x more
func RunMulBasketUpgrade():
	#clickers.remove_at(index)
	var basketNode = get_parent().duplicate()
	basketNode.name = str("Basket", modifications[3][1])
	
	#The first basket should be the only one to upgrade the Hand Clicker, 
	#	Multi Basket, and Yarn Evolution
	basketNode.clickers.remove_at(0)
	basketNode.Modifications.remove_at(3)
	basketNode.Modifications.remove_at(4)
	
	get_parent().add_child(basketNode)
	pass

func RunMultiYarn():
	pass
	
func RunGoldenYarn():
	pass
	
func RunYarnatonic():
	pass
	
func RunYarnEvolution():
	pass

#endregion Modifications


#region Helper Functions

func GetUpgradeCost(index, type, mul = 1):
	if type == clickers[0].type:
		return cursor[0].GetCost(multiplyer, mul) if index == 0 else clickers[index-1].GetCost(multiplyer, mul)
	elif type == enhancments[0].type:
		return enhancments[index].GetCost(multiplyer)
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
	var basketYPS = 0
	
	#Run through all the clickers and calculate the YPS
	for index in clickers.size():
		#No need to continue if the clicker has not been purchased
		if(clickers[index].ammount == 0):
			continue

		var clickerYPS = clickers[index].GetGenerationAmount(enhancments[index].multiplyer)
		
		#Earn an additinal 1% per evolution level
		if modifications[4].ammount != null && modifications[4].ammount > 0:
			clickerYPS *= (modifications[4].ammount * 1.1)
		
		basketYPS += clickerYPS
		pass
	
	return basketYPS
	pass
	

#endregion Helper Functions
