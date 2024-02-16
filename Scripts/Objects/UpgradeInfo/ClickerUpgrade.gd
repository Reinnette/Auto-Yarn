extends Upgrade
class_name ClickerUpgrade

var level: int #The level of the clicker
var generation: String #Amount generated per second
var costExpnt

func _init(_baseCost, _costExpnt, _generation, genExpnt):
	baseCost = str(_baseCost)
	
	costExpnt = _costExpnt
	for count in costExpnt:
		baseCost += "0"
	
	generation = str(_generation)
	
	for count in genExpnt:
		generation += "0"
	
	type = upgrades.Clickers
	pass
	
func GetGenerationAmount(mul = 1):
	var gen = LInt.new()
	gen.lint = generation
	gen.Mul((ammount+1) * mul)
	var i = gen.lint
	var ints = gen.ConvertToInts()
	return gen.ConvertToInts()
