extends Node

@onready var rootNode = find_parent("MainView").get_path()
@onready var I18nPath = str(rootNode, "/I18n")

func _ready():
	get_node(I18nPath).loadI18n.connect(I18n)
	
func I18n(translations):
	var key = str("T_", name)
	
	if(!translations.has(key)):
		get_node(I18nPath).CreateI18n(key, "No I18n")
		self.text = "No I18n"
		return
	
	self.text = translations[key]
	pass
