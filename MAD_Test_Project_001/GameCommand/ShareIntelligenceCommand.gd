extends "res://GameCommand/GameCommand.gd"

var Package_Name : String = ""
var SendTo_Country : String = ""
var SendFrom_Country : String = ""
var WorldController : Node = null

func _ready():
	SetName("Share_Intelligence_Command")

func execution() -> bool:
	if WorldController == null || Package_Name.empty() || SendTo_Country.empty() || SendFrom_Country.empty():
		return false
	
	var sendToCountry : Node = WorldController.getCountryByName(SendTo_Country)
	var sentFromCountry : Node = WorldController.getCountryByName(SendFrom_Country)
	var intelligencePackage : Resource = sentFromCountry.getIntelligencePackage(Package_Name)
	
	if intelligencePackage == null:	
		return false
			
	sendToCountry.addReceivedIntelligencePackage(intelligencePackage)
	
	return true
