extends Node

@onready var i18n: String = str(find_parent("MainView").get_path(), "/I18n")
@onready var i18nNode: Node = get_node(i18n)

func _ready():
	i18nNode.loadI18n.connect(I18n)
	
func I18n(translations):
	var key = str("T_", name)
	
	if(!translations.has(key)):
		i18nNode.CreateI18n(key, "No I18n")
		self.text = "No I18n"
		return
	
	self.text = translations[key]
	pass
