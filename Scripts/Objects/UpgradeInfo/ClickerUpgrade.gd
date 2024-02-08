extends Upgrade
class_name ClickerUpgrade

var level: int #The level of the clicker
var generation: float #Amount generated per second

func _init(_baseCost, costExpnt, _generation, genExpnt):
	baseCost = str(_baseCost)
	generation = _generation
	type = upgrades.Clickers
	pass
	
func GetGenerationAmount(mul = 1):
	return generation * ammount * mul
