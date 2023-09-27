extends "res://GameCommand/GameCommand.gd"

var Package_Name : String = ""
var Created_By_Country : String = ""
var Intel_List : Array = []
var WorldController : Node = null

func _ready():
	SetName("Create_Intelligence_Package_Command")

func execution() -> bool:
	if WorldController == null || Package_Name.empty() || Created_By_Country.empty() || Intel_List.size() < 1:
		return false
		
	var intelPackage = IntelligencePackageResourceDef.new()
	intelPackage.PackageName = Package_Name
	intelPackage.IntelligenceForEntities = Intel_List
	
	var country : Node = WorldController.getCountryByName(Created_By_Country)
	country.addIntelPackage(intelPackage)
	
	return true
