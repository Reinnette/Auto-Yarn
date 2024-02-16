extends Control

@onready var rootNode: String = find_parent("MainView").get_path()
@onready var m_gameController: Node = get_node(str(rootNode, "/GameController"))
@onready var m_upgradeHelper: Node = get_node(str(str(rootNode, "/Baskets/Basket"), m_gameController.currentBasket))
@onready var m_I18n: Node = get_node(str(rootNode, "/I18n"))
@onready var m_I18nScript = load("res://Scripts/T_I18n.gd")

var m_isSell = false
var isSell:
	get:
		return m_isSell
	set(value):
		m_isSell = value
		get_node("../Multiplyers/Sell").text = m_I18n.GetI81nT("T_Buy") if isSell else m_I18n.GetI81nT("T_Sell")
	
var currentMul = 1
var selectedMul = 1:
	get:
		return currentMul
	set(value):
		currentMul = value
		MulChanged()
		
signal refreshSignal(yarn: LInt, shopMul: int, selectedMul: int)

#region Shop Upgrades Nodes
var hasLoadedClickers = false
var hasLoadedUpgrades = false
var hasLoadedMods = false

func LoadShop():
	
	if !hasLoadedClickers:
		GenerateClickers()
		
	if !hasLoadedUpgrades:
		GenerateUpgrades()
		
	if !hasLoadedMods:
		GenerateModifications()
	
	#Make sure Clickers is selected by default
	SwapUpgrades(0)
	emit_signal("refreshSignal", m_gameController.yarn, m_upgradeHelper.multiplyer, selectedMul)
	pass

func GenerateClickers():
	hasLoadedClickers = true
	var newUpgrade = get_node("Clickers/Container/Upgrade").duplicate()
	get_node("Clickers/Container/Upgrade").queue_free()
	
	var upgradeList = m_upgradeHelper.clickers
	for indexId in upgradeList.size()+1:
		#If where the first item add the cursur upgrade
		var clickerInfo = m_upgradeHelper.cursor[0] if indexId == 0 else m_upgradeHelper.clickers[indexId-1]
		var newChild = newUpgrade.duplicate()
		get_node("Clickers/Container").add_child(newChild)

		var type = Upgrade.new().upgrades.keys()[clickerInfo.type]
		var node = GenerateUpgrade(newChild, str(type, indexId), indexId, clickerInfo.type)
		if indexId == 0:
			m_upgradeHelper.cursor[indexId].upgradeNode = node
			m_upgradeHelper.cursor[indexId].Connect(refreshSignal, m_I18n)
		else:
			upgradeList[indexId-1].upgradeNode = node
			upgradeList[indexId-1].Connect(refreshSignal, m_I18n)
		pass
	pass
	
func GenerateUpgrades():
	hasLoadedUpgrades = true
	var newUpgrade = get_node("Enhancement/Container/Upgrade").duplicate()
	get_node("Enhancement/Container/Upgrade").queue_free()
	
	var upgradeList = m_upgradeHelper.enhancments
	for indexId in upgradeList.size():
		var enhancmentsInfo = upgradeList[indexId]
		var newChild = newUpgrade.duplicate()
		get_node("Enhancement/Container").add_child(newChild)
		
		var enhancmentMul = upgradeList[indexId].GetMul() + 1
		var name = str(enhancmentsInfo.type, indexId, "_", enhancmentMul)
		var node = GenerateUpgrade(newChild, name, indexId, enhancmentsInfo.type)
		
		upgradeList[indexId].upgradeNode = node
		upgradeList[indexId].Connect(refreshSignal, m_I18n)
		pass
	pass
	
func GenerateModifications():
	hasLoadedMods = true
	var newUpgrade = get_node("Mods/Container/Upgrade").duplicate()
	get_node("Mods/Container/Upgrade").queue_free()
	
	var upgradeList = m_upgradeHelper.modifications
	for indexId in upgradeList.size():
		var modInfo = upgradeList[indexId]
		var newChild = newUpgrade.duplicate()
		get_node("Mods/Container").add_child(newChild)

		var node = GenerateUpgrade(newChild, str(modInfo.type, indexId), indexId, modInfo.type)
		
		upgradeList[indexId].upgradeNode = node
		upgradeList[indexId].Connect(refreshSignal, m_I18n)
		pass
	pass
	
func GenerateUpgrade(newChild, name, indexId, upgradeType):
	
	var upgrade = newChild
	upgrade.visible = true
	upgrade.name = name
	upgrade.get_node("Info/Name").text = m_I18n.GetI81nT(str("T_", name))
	upgrade.get_node("Info/Name").set_script(m_I18nScript)
	upgrade.get_node("Info/Name").name = name
	upgrade.get_node("Info/Desc").text = m_I18n.GetI81nT(str("T_", name, "_Desc"))
	upgrade.get_node("Info/Desc").set_script(m_I18nScript)
	upgrade.get_node("Info/Desc").name = str(name, "_Desc")
	upgrade.get_node("Upgrade").id = indexId
	upgrade.get_node("Upgrade").upgradeType = upgradeType
	
	return upgrade
	pass
	
#Hide all of the Upgrades and show the selected one
func SwapUpgrades(id):
	for child in get_children():
		child.visible = false
		
	get_child(id).visible = true
	isSell = false
	pass

func UpgradeButtonPressed(id, upgradeType):
	var cost
	if isSell:
		if upgradeType == m_upgradeHelper.clickers[0].type:
			if(m_upgradeHelper.clickers[id].ammount == 0):
				return
			
			cost = m_upgradeHelper.clickers[id].DecAmount(m_upgradeHelper.multiplayer, selectedMul, m_gameController.yarn)
			m_gameController.yarn.Add(cost)
	else:	
		if upgradeType == m_upgradeHelper.clickers[0].type:
			if id == 0:
				cost = m_upgradeHelper.cursor[id].UpgradeTrigger(m_gameController.yarn, selectedMul, m_upgradeHelper.multiplayer)
			else:
				m_upgradeHelper.clickers[id-1].UpgradeTrigger(m_gameController.yarn, selectedMul, m_upgradeHelper.multiplayer)
		elif upgradeType == m_upgradeHelper.enhancments[0].type:
			m_upgradeHelper.enhancments[id].UpgradeTrigger()
			pass
		elif upgradeType == m_upgradeHelper.modifications[0].type:
			m_upgradeHelper.modifications[id].UpgradeTrigger()
			pass
			
		m_gameController.yarn.Minus(cost)
		pass
		
	m_gameController.yarn = m_gameController.yarn.lint
	pass
#endregion

#region Shop Multiplyer Buttons

func _on_sell_pressed():
	isSell = !isSell
	pass 

func _on_1_pressed():
	selectedMul = 1
	pass 
	
func _on_10_pressed():
	selectedMul = 10
	pass 

func _on_100_pressed():
	selectedMul = 100
	pass 
	
func _on_max_pressed():
	selectedMul = 999
	pass 
	
#This function is called every time the Multiplyer Value Changes
#	as well as every second from the GameController in _process
var lastYarnVal = []
func MulChanged(liveUpdate = false):
	
	var listYarn = m_gameController.yarn.ConvertToInts()
	if(listYarn == lastYarnVal && liveUpdate):
		return
		
	lastYarnVal = listYarn
	emit_signal("refreshSignal", m_gameController.yarn, m_upgradeHelper.multiplyer, selectedMul)
	pass
	
#endregion11

#region UpgradeTypes
func ViewClickers():
	SwapUpgrades(0)
	
func ViewEnhancement():
	SwapUpgrades(1)

func ViewMods():
	SwapUpgrades(2)
#endregion
