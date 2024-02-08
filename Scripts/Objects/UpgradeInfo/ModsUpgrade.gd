extends Upgrade
class_name ModsUpgrade

var funcToCall: Callable

func _init(_baseCost, costExpnt, function):
	baseCost = str(_baseCost)
	funcToCall = function
	type = upgrades.Mods

func UpgradeTrigger():
	funcToCall.call()
