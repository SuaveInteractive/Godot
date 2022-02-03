extends Resource
class_name WorldInformation

enum AllianceStatus {ALLIANCESTATUS_ALLIED, ALLIANCESTATUS_NOTALLIED, ALLIANCESTATUS_ATWAR}

export(int) var NumberOfCountries = 0
export(Array, AllianceStatus) var CountriesAllianceStatus
export(Array, Resource) var Countries
export(Array, Resource) var Modifiers # Modifers that apply to the entire world.

# Map Information
export(PackedScene) var MapScene = null
#export(Texture) var Map = null

