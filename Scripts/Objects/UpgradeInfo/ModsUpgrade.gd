extends Upgrade
class_name ModsUpgrade

var funcToCall: Callable

func _init(_baseCost, costExpnt, function):
	baseCost = str(_baseCost)
	
	for count in costExpnt:
		baseCost += "0"
	
	funcToCall = function
	type = upgrades.Mods

func UpgradeTrigger(currentYarn, mul = 1, shopMul = 1):
	funcToCall.call()
