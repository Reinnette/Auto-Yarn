extends Node

signal loadI18n(T_)
var lang = "en-us"
var translations = {}

func _ready():
	GetNewI18n()
	
var timepassed = 0
var hasInitilized = false
func _process(delta):
	if hasInitilized:
		return
	
	timepassed += delta
	
	if timepassed > 0.25:
		hasInitilized = true
	
	if !hasInitilized:
		return
	
	emit_signal("loadI18n", translations)

#Get the new language file data
func GetNewI18n():
	
	var file = FileAccess.open(str("res://I18n/", lang, ".txt"), FileAccess.READ)
	var json_text = file.get_as_text()
	var my_json = JSON.new()
	var parse_result = my_json.parse(json_text)

	if parse_result != OK:
		print("Error %s reading json file." % parse_result)
		return

	translations = my_json.get_data()
	
#Gets a specific translation value
func GetI81nT(key):
	
	if(translations == null):
		print("Fatal")
		return
	
	if !translations.has(key):
		CreateI18n(key, "No I18n")
		return "No I18n"
	
	return translations[key]

#If a missing translation is found add it to the list
func CreateI18n(key, value):
	translations[key] = value
	UpdateTranslations()
	pass

#Set the new translations to the values on screen
func UpdateTranslations():
	print("Updating Translations")
	SaveI18n()
	pass

func SaveI18n():
	var file = FileAccess.open(str("res://I18n/", lang, ".txt"), FileAccess.WRITE)
	file.store_line(JSON.stringify(translations, "\t"))
	file.close()
	pass
