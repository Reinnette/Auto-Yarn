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
var mul:
	get:
		return currentMul
	set(value):
		currentMul = value
		MulChanged()
		
enum upgrades {Clickers, Enhancement, Mods}

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
	
	for indexId in m_upgradeHelper.clickers.size():
		var clickerInfo = m_upgradeHelper.clickers[indexId]
		var newChild = newUpgrade.duplicate()
		get_node("Clickers/Container").add_child(newChild)

		var cost = m_upgradeHelper.GetClickerCost(indexId, mul)
		
		GenerateUpgrade(newChild, clickerInfo[0], clickerInfo[2], cost, indexId, upgrades.Clickers)
		pass
	pass
	
func GenerateUpgrades():
	hasLoadedUpgrades = true
	var newUpgrade = get_node("Enhancement/Container/Upgrade").duplicate()
	get_node("Enhancement/Container/Upgrade").queue_free()
	
	for indexId in m_upgradeHelper.clickers.size():
		var clickerInfo = m_upgradeHelper.clickers[indexId]
		var newChild = newUpgrade.duplicate()
		get_node("Enhancement/Container").add_child(newChild)

		var clickerMul = m_upgradeHelper.GetAutoClickerSU(indexId) + 1
		var cost = m_upgradeHelper.GetModCost(indexId)
		var name = str(clickerInfo[0], clickerMul)
		
		GenerateUpgrade(newChild, name, clickerMul, cost, indexId, upgrades.Enhancement)
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

		var cost = m_upgradeHelper.GetModsCost(indexId, mul)
		
		GenerateUpgrade(newChild, modInfo[0], "", cost, indexId, upgrades.Mods)
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
	upgrade.get_node("Upgrade").text = str(get_node(i18n).GetI81nT("T_Cost"),  cost)
	upgrade.get_node("Upgrade").id = indexId
	upgrade.get_node("Upgrade").upgradeType = upgradeType
	upgrade.get_node("Upgrade").set_script(m_I18nScript)
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
		if upgradeType == upgrades.Clickers:
			if(m_upgradeHelper.GetClickerAmount(id) == 0):
				return
			
			m_upgradeHelper.DecAutoClickerAmount(id, multiplyer)
			m_gameController.yarn += cost
	else:
		if(m_gameController.yarn < cost):
			return
		
		var yarnLeft = m_gameController.yarn - cost
		m_gameController.yarn = yarnLeft
		
		if upgradeType == upgrades.Clickers:
			m_upgradeHelper.IncAutoClickerAmount(id)
		elif upgradeType == upgrades.Enhancement:
			m_upgradeHelper.IncAutoClickerMul(id)
			pass
		elif upgradeType == upgrades.Mods:
			m_upgradeHelper.IncModsAmount(id)
			pass
		pass
		
	cost = GetUpgradeCost(upgradeType, id, multiplyer)
	
	FindNodeById(get_node(upgradeType), id)
	btnToUpdate.text = str(i18n.GetI81nT("T_Cost"), cost)
	pass
	
func GetUpgradeCost(upgradeType, id, multiplyer):
	if(upgradeType == upgrades.Clickers):
		return m_upgradeHelper.GetClickerCost(id, multiplyer)
	elif upgradeType == upgrades.Enhancement:
		return m_upgradeHelper.GetModCost(id)
	elif upgradeType == upgrades.Mods:
		return m_upgradeHelper.GetModsCost(id, multiplayer)
		pass
	
	
func FindNodeById(node, id):
	for children in node.get_children():
		if children.get_child_count() > 0:
			FindNodeById(children, id)
		else:
			if children.name == "Upgrade":
				if children.id == id:
					btnToUpdate = children
			pass
	pass
#endregion

#region Shop Multiplyer Buttons

func _on_sell_pressed():
	isSell = !isSell
	pass 

func _on_1_pressed():
	mul = 1
	pass 
	
func _on_10_pressed():
	mul = 10
	pass 

func _on_100_pressed():
	mul = 100
	pass 
	
func _on_max_pressed():
	mul = 999
	pass 
	
#This function is called every time the Multiplyer Value Changes
#	as well as every second from the GameController in _process
var lastYarnVal = 0
func MulChanged(liveUpdate = false):
	
	if(m_gameController.yarn == lastYarnVal):
		return
		
	lastYarnVal = m_gameController.yarn
	
	#Updeate Clickers
	for index in m_upgradeHelper.clickers.size():
		
		#Do not update if there are no items to update
		if !hasLoadedClickers:
			return

		var clicker = get_node("Clickers/Container").get_child(index)
		
		#If there was no node found then dont try to update one
		if clicker == null:
			continue
		
		var multiplyer = GetMultiplyer(index, upgrades.Clickers)
		var cost = m_upgradeHelper.GetClickerCost(index, multiplyer)
		var disabled = m_gameController.yarn < cost
		
		#Update the button text with the new value
		clicker.get_child(2).text = str(i18n.GetI81nT("T_Cost"), cost)
		clicker.get_child(2).disabled = disabled
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
		
		var multiplyer = GetMultiplyer(index, upgrades.Enhancement)
		
		var baseCost = m_upgradeHelper.GetClickerCost(index, multiplyer)
		var clickerMul = m_upgradeHelper.GetAutoClickerSU(index)
		var cost = baseCost * 1.25 * (clickerMul * 1.25)
		var disabled = m_gameController.yarn < cost
		
		#Update the button text with the new value
		enhancement.get_child(2).text = str(i18n.GetI81nT("T_Cost"), cost)
		enhancement.get_child(2).disabled = disabled
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
		
		var multiplyer = GetMultiplyer(index, upgrades.Mods)
		var cost = m_upgradeHelper.GetModsCost(index, multiplyer)
		var disabled = m_gameController.yarn < cost
		
		#Update the button text with the new value
		mod.get_child(2).text = str(i18n.GetI81nT("T_Cost"), cost)
		mod.get_child(2).disabled = disabled
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
	if(mul == 999):
		var yarn = m_gameController.yarn
		
		if(upgradeType == upgrades.Clickers):
			#Current multiplyer is yarn over base cost hence the use of "1"
			#	in the get cost
			return floor(yarn / m_upgradeHelper.GetClickerCost(index, 1))
		elif upgradeType == upgrades.Enhancement:
			return m_upgradeHelper.GetModCost(index)
		elif upgradeType == upgrades.Mods:
			return floor(yarn / m_upgradeHelper.GetModsCost(index, 1))
			pass
		pass
		
	return mul
	pass
