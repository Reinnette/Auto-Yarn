extends Node

var multiplyer = 1
var yarnInBasket = [1]#The Yarn on screen and the level of the yarn

#Cursor, 			Level, Cost, Generation(P/S), Multiplyer
var cursor = ["Cursor", 0, 	str(10),				1, 		100]

#Clicker, 			Amount, Level, Cost, 		Generation(P/S), Multiplyer
var clickers = [
	["Hand", 			0, 0, str(12), 				0.1, 				100],
	["Needles", 		0, 0, str(80), 				1, 					100],
	["Kittens", 		0, 0, str(1080), 			8, 					100],
	["Yarn Farm", 		0, 0, str(12 * (10 ** 3)), 	47, 				100],
	["Mamma Cat", 		0, 0, str(13 * (10 ** 4)), 	260, 				100],
	["Scissors", 		0, 0, str(14 * (10 ** 5)), 	1400, 				100],
	["Bank of Yarn", 	0, 0, str(2 * (10 ** 7)), 	7800, 				100],
	["Baby Dragon", 	0, 0, str(33 * (10 ** 7)), 	44 * (10 ** 3), 	100],
	["Research Center", 0, 0, str(51 * (10 ** 8)), 	260 * (10 ** 3), 	100],
	["Shredder",		0, 0, str(75 * (10 ** 9)), 	16 * (10**5), 		100],
	["Loom", 			0, 0, str(1 * (10 ** 12)), 	10 * (10**6), 		100],
	["Toxic Brew",		0, 0, str(14 * (10 ** 12)),	65 * (10**6), 		100],
	["Milk Factory", 	0, 0, str(170 * (10 ** 12)),430 * (10**6), 		100],
	["Kitten Temple", 	0, 0, str(21 * (10 ** 14)), 29 * (10**8), 		100],
	["Anti-Mater", 		0, 0, str(26 * (10 ** 15)),	21 * (10**9), 		100],
	["Time Bomb", 		0, 0, str(310 * (10 ** 15)),150 * (10**9),		100],
	["Atom-Spliter", 	0, 0, str(71 * (10 ** 18)), 11 * (10**11), 		100],
	["Black-Cat Luck", 	0, 0, str(12 * (10 ** 21)),	83 * (10**11), 		100],
	["Comet Storm", 	0, 0, str(19 * (10 ** 21)),	64 * (10**12), 		100],
	["Black Hole", 		0, 0, str(540 * (10 ** 21)),510 * (10**12), 	100]
	]

#Mod, 				Amount, Cost
var modifications = [
	["Multi-Yarn", 		0, str(40 * 10 ** 6)],
	["Golden Yarn", 	0, str(400 * 10 ** 6)],
	["Yarnatonic", 		0, str(9999)],
	["Multi-Basket", 	0, str(60 * (10 ** 6))],
	["Yarn Evolution", 	0, str(9999)]#Need to have gotten X yarn. Perstege points are yarn / X
]

#Increase item efficiency/Production rate, 
#For Get SU methods they will return the following
#	1 - Uncommon (Grey)
#	2 - Common (Green)
#	3 - Rare (Blue)
#	4 - Epic (Purple)
#	5 - Legindary (Gold)
#	

#region Cursor

func GetCursorCost(mul = 1):
	return CalcUpgradeCost(cursor[1], cursor[2], mul)
	
func GetCursorMul():
	return (cursor[4] - 100) / 20
	
func IncCursorAmount():
	cursor[1] += 1
	
func IncCursorMul():
	cursor[4] += 20

#endregion

#region Clickers
func GetClickerCost(clickerId, mul = 1):
	return CalcUpgradeCost(clickers[clickerId][1] + 1, clickers[clickerId][3], mul)
	pass

func GetClickerAmount(clickerId):
	return clickers[clickerId][1]
	pass
	
func GetClickerLevel(clickerId):
	return clickers[clickerId][2]
	pass

func GetAutoHandMulCost(clickerId, mul = 1):
	return CalcUpgradeCost(GetAutoClickerSU(clickerId), (clickers[clickerId][5]), mul)
	pass
	
func GetAutoClickerSU(clickerId):
	return (clickers[clickerId][5] - 100) / 20
	pass

func IncAutoClickerMul(clickerId):
	clickers[clickerId][5] += 20
	pass
	
func IncAutoClickerAmount(clickerId):
	clickers[clickerId][1] += 1
	print(clickers[clickerId][1])
	pass

func IncAutoClickerLevel(clickerId):
	clickers[clickerId][2] += 2
	pass
	
func DecAutoClickerAmount(clickerId, amount):
	clickers[clickerId][1] -= amount
	pass

func GetModCost(clickerId):
	var clickerMul = GetAutoClickerSU(clickerId) + 1
	var mul = 1.1 * (clickerMul * 1.1)
	var baseCost = GetClickerCost(clickerId, mul)
	return baseCost
	pass
	
#endregion

#region Multi Use

#Multi Yarn - adds another yarn to unravel
#Golden Yarn - every X layers will be golden varient giving 10x 
#Yarntonic - special potion that makes the Yarn stronger advancing it by X Layers
#Multi Basket - Adds another basket to unravel Yarn in (Note: cost of the upgrades in the new basket you go up by 10x but also reward 7x more)
#Yarn Evolution - Reset your current standing where Yarn is stronger(+10%) and gain X special points
	
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

func GetModsCost(modId, mul = 1):
	return CalcUpgradeCost(modifications[modId][1] + 1, modifications[modId][2], mul)
	pass
	
func IncModsAmount(modId):
	modifications[modId][1] += 1
	pass

#endregion Multi Use


#region Helper Functions

func HaveAutoClicker():
	var hasAuto = false
	
	for index in range(0,clickers.size()):
		var clickerInfo = clickers[index]
		
		if(hasAuto):
			continue
			
		if(clickerInfo[1] > 0):
			hasAuto = true
			
		pass
		
	return hasAuto
	pass
	

func CalcUpgradeCost(level, cost, shopMul):
	var yarnCost: Yarn = Yarn.new()
	yarnCost.yarn = cost
	
	yarnCost.Mul(level * 1.15)
	yarnCost.Mul(1.15)
	yarnCost.Mul(multiplyer)
	yarnCost.Mul(shopMul)
	
	return yarnCost.ConvertToInts()
	
	
func GetBasketYPS():#Gets this baskets yarn per second(YPS)
	var basketYPS = 0
	
	#Run through all the clickers and calculate the YPS
	for index in clickers.size():
		#No need to continue if the clicker has not been purchased
		if(clickers[index][1] == 0):
			continue
		
		var amount = GetClickerAmount(index)
		var yps = clickers[index][4]
		var mul = GetAutoClickerSU(index) + 1
		
		var clickerYPS = (amount * yps) * mul
		
		#Earn an additinal 1% per evolution level
		if modifications[4][1] != null && modifications[4][1] > 0:
			clickerYPS *= (modifications[4][1] * 1.1)
		
		basketYPS += clickerYPS
		pass
	
	return basketYPS
	pass
	

#endregion Helper Functions
