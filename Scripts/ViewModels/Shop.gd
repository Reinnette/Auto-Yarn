extends Button

@onready var rootNode = find_parent("MainView").get_path()
@onready var I18nPath = str(rootNode, "/I18n")

var upgradesShown = false
func _pressed():
	var views = get_node("../../../")
	var upgrade = views.get_node("Shop/Control/ListOfUpgrades")
	
	
	if !upgradesShown:
		upgrade.LoadShop()
		views.get_node("Shop").visible = true
		upgradesShown = true
	else:
		views.get_node("Shop").visible = false
		upgradesShown = false
	
	pass
	
func _ready():
	get_node(I18nPath).loadI18n.connect(I18n)

func I18n(translations):
	var scene = get_path().get_concatenated_names()
	var key = str("T_", scene.replace("/", "_"))
	
	if(!translations.has(key)):
		get_node(I18nPath).CreateI18n(key, "No I18n")
		text = "No I18n"
		return
	
	text = translations[key]
	pass

