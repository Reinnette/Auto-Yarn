extends Control

@onready var rootNode = find_parent("MainView").get_path()
@onready var gameControllerPath = str(rootNode, "/GameController")
@onready var basketPath = str(rootNode, "/Baskets/Basket")
@onready var i18n = str(rootNode, "/I18n")

@onready var m_gameController = get_node(gameControllerPath)
@onready var m_upgradeHelper = get_node(str(basketPath, m_gameController.currentBasket))
@onready var m_I18n = get_node(i18n)
@onready var m_I18nScript = load("res://Scripts/T_I18n.gd")

var m_isSell = false
var isSell:
	get:
		return m_isSell
	set(value):
		m_isSell = value
		get_node("../Multiplyers/Sell").text = get_node(i18n).GetI81nT("T_Buy") if isSell else get_node(i18n).GetI81nT("T_Sell")
	
var currentMul = 1
var selectedMul = 1:
	get:
		return currentMul
	set(value):
		currentMul = value
		MulChanged()

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
	
	pass

func GenerateClickers():
	hasLoadedClickers = true
	var newUpgrade = get_node("Clickers/Container/Upgrade").duplicate()
	get_node("Clickers/Container/Upgrade").queue_free()
	
	for indexId in m_upgradeHelper.clickers.size()+1:
		#If where the first item add the cursur upgrade
		var clickerInfo = m_upgradeHelper.cursor[0] if indexId == 0 else m_upgradeHelper.clickers[indexId-1]
		var newChild = newUpgrade.duplicate()
		get_node("Clickers/Container").add_child(newChild)

		var cost = m_upgradeHelper.GetUpgradeCost(indexId, clickerInfo.type, selectedMul)
		
		var type = Upgrade.new().upgrades.keys()[clickerInfo.type]
		GenerateUpgrade(newChild, str(type, indexId), clickerInfo.ammount, cost, indexId, clickerInfo.type)
		pass
	pass
	
func GenerateUpgrades():
	hasLoadedUpgrades = true
	var newUpgrade = get_node("Enhancement/Container/Upgrade").duplicate()
	get_node("Enhancement/Container/Upgrade").queue_free()
	
	for indexId in m_upgradeHelper.enhancments.size():
		var enhancmentsInfo = m_upgradeHelper.enhancments[indexId]
		var newChild = newUpgrade.duplicate()
		get_node("Enhancement/Container").add_child(newChild)

		var enhancmentMul = m_upgradeHelper.enhancments[indexId].GetMul() + 1
		var cost = m_upgradeHelper.GetUpgradeCost(indexId, enhancmentsInfo.type, selectedMul)
		var name = str(enhancmentsInfo.type, indexId, "_", enhancmentMul)
		
		GenerateUpgrade(newChild, name, enhancmentMul, cost, indexId, enhancmentsInfo.type)
		pass
	pass
	
func GenerateModifications():
	hasLoadedMods = true
	var newUpgrade = get_node("Mods/Container/Upgrade").duplicate()
	get_node("Mods/Container/Upgrade").queue_free()
	
	for indexId in m_upgradeHelper.modifications.size():
		var modInfo = m_upgradeHelper.modifications[indexId]
		var newChild = newUpgrade.duplicate()
		get_node("Mods/Container").add_child(newChild)

		var cost = m_upgradeHelper.GetUpgradeCost(indexId, modInfo.type)
		
		GenerateUpgrade(newChild, str(modInfo.type, indexId), "", cost, indexId, modInfo.type)
		pass
	pass
	
func GenerateUpgrade(newChild, name, level, cost, indexId, upgradeType):
	
	var upgrade = newChild
	upgrade.visible = true
	upgrade.name = name
	upgrade.get_node("Info/Name").text = get_node(i18n).GetI81nT(str("T_", name))
	upgrade.get_node("Info/Name").set_script(m_I18nScript)
	upgrade.get_node("Info/Name").name = name
	upgrade.get_node("Info/Desc").text = get_node(i18n).GetI81nT(str("T_", name, "_Desc"))
	upgrade.get_node("Info/Desc").set_script(m_I18nScript)
	upgrade.get_node("Info/Desc").name = str(name, "_Desc")
	upgrade.get_node("Level Control/Level").text = str("LvL: ", level)
	upgrade.get_node("Upgrade/Cost").text = str(get_node(i18n).GetI81nT("T_Cost"),  cost[0])
	upgrade.get_node("Upgrade").id = indexId
	upgrade.get_node("Upgrade").upgradeType = upgradeType
	#upgrade.get_node("Upgrade").set_script(m_I18nScript)
	pass
	
#Hide all of the Upgrades and show the selected one
func SwapUpgrades(id):
	for child in get_children():
		print(child.name)
		child.visible = false
		
	get_child(id).visible = true
	isSell = false
	pass

var btnToUpdate
func UpgradeButtonPressed(id, upgradeType):
	var multiplyer = GetMultiplyer(id, upgradeType)
	
	var cost = GetUpgradeCost(upgradeType, id, multiplyer)
		
	if isSell:
		if upgradeType == m_upgradeHelper.clickers[0].type:
			if(m_upgradeHelper.clickers[id].ammount == 0):
				return
			
			m_upgradeHelper.clickers[id].DecAmount(multiplyer)
			m_gameController.yarn.Add(cost)
	else:
		if(!m_gameController.yarn.IsGreaterThan(cost)):
			return
		
		m_gameController.yarn.Minus(cost)
		#m_gameController.yarn = yarnLeft
		
		if upgradeType == m_upgradeHelper.clickers[0].type:
			if id == 0:
				m_upgradeHelper.cursor[id].IncAmount(multiplyer)
			else:
				m_upgradeHelper.clickers[id-1].IncAmount(multiplyer)
		elif upgradeType == m_upgradeHelper.enhancements[0].type:
			m_upgradeHelper.enhancements[id].IncAmmount()
			pass
		elif upgradeType == m_upgradeHelper.mods[0].type:
			m_upgradeHelper.mods[id].IncAmount()
			pass
		pass
		
	cost = GetUpgradeCost(upgradeType, id, multiplyer)
	
	var type = Upgrade.new().upgrades.keys()[upgradeType]
	FindNodeById(get_node(type), id, type)
	
	#Update display text
	btnToUpdate.get_node("Cost").text = str(get_node(i18n).GetI81nT("T_Cost"), cost[0])
	pass
	
func GetUpgradeCost(upgradeType, id, multiplyer = 1):
	return m_upgradeHelper.GetUpgradeCost(id, upgradeType, multiplyer)
	
	
func FindNodeById(node, id, type):
	for children in node.get_children():
		if children.get_child_count() > 0:
			if children.name == "Upgrade" && children.id == id:
					btnToUpdate = children
			else:
				FindNodeById(children, id, type)
		else:
			print(children.name)
			if children.name == "Upgrade" && children.id == id:
					btnToUpdate = children
			pass
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
	if(listYarn == lastYarnVal):
		return
		
	lastYarnVal = listYarn
	
	#Updeate Clickers
	for index in m_upgradeHelper.clickers.size():
		
		#Do not update if there are no items to update
		if !hasLoadedClickers:
			return

		var clicker = get_node("Clickers/Container").get_child(index)
		
		#If there was no node found then dont try to update one
		if clicker == null:
			continue
		
		var multiplyer = GetMultiplyer(index, m_upgradeHelper.clickers[0].type)
		var cost = m_upgradeHelper.GetUpgradeCost(index, m_upgradeHelper.clickers[0].type, multiplyer)
		var yarn = m_gameController.yarn
		var disabled = yarn.IsGreaterThan(cost)
		
		#Update the button text with the new value
		clicker.get_node("Upgrade/Cost").text = str(get_node(i18n).GetI81nT("T_Cost"), cost[0])
		clicker.get_child(2).disabled = !disabled
		pass
	
	#Update Upgrades
	for index in m_upgradeHelper.clickers.size():
		
		#Do not update if there are no items to update
		if !hasLoadedUpgrades:
			return

		var enhancement = get_node("Enhancement/Container").get_child(index)
		
		#If there was no node found then dont try to update one
		if enhancement == null:
			continue
		
		var multiplyer = GetMultiplyer(index, m_upgradeHelper.enhancments[0].type)
		
		var baseCost = m_upgradeHelper.GetUpgradeCost(index, m_upgradeHelper.enhancments[0].type, multiplyer)
		var clickerMul = m_upgradeHelper.enhancments[index].GetMul()
		var cost = baseCost[0] * 1.25 * (clickerMul+1 * 1.25)
		var yarn = m_gameController.yarn
		var disabled = yarn.IsGreaterThan([cost])
		
		#Update the button text with the new value
		enhancement.get_node("Upgrade/Cost").text = str(get_node(i18n).GetI81nT("T_Cost"), cost)
		enhancement.get_child(2).disabled = !disabled
		pass
	
	#Update Modifications
	for index in m_upgradeHelper.modifications.size():
		
		#Do not update if there are no items to update
		if !hasLoadedClickers:
			return

		var mod = get_node("Mods/Container").get_child(index)
		
		#If there was no node found then dont try to update one
		if mod == null:
			continue
		
		var multiplyer = GetMultiplyer(index, m_upgradeHelper.modifications[0].type)
		var cost = m_upgradeHelper.GetUpgradeCost(index, m_upgradeHelper.modifications[0].type, multiplyer)
		var yarn = m_gameController.yarn
		var disabled = yarn.IsGreaterThan(cost)
		
		#Update the button text with the new value
		mod.get_node("Upgrade/Cost").text = str(get_node(i18n).GetI81nT("T_Cost"), cost)
		mod.get_child(2).disabled = !disabled
		pass
	
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

func GetMultiplyer(index, upgradeType):
	#If the multiplyer is set to Max then get the max Multiplyer that 
		#	can be afforded for this node
	if(selectedMul == 999 && upgradeType == m_upgradeHelper.clickers[0].type):
		var yarn = m_gameController.yarn
		return floor(yarn / GetUpgradeCost(upgradeType, index))
		
	return selectedMul
	pass
