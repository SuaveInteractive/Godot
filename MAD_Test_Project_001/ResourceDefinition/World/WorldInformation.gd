extends Resource
class_name WorldInformation

enum AllianceStatus {ALLIANCESTATUS_ALLIED, ALLIANCESTATUS_NOTALLIED, ALLIANCESTATUS_ATWAR}

export(int) var Version 

export(Array, Resource) var Countries
export(Array, Resource) var Units
export(Array, Resource) var Buildings
export(Array, Resource) var Modifiers # Modifers that apply to the entire world.

# Map Information
export(Texture) var Map = null
export(NavigationPolygon) var LandNavigation = null
export(NavigationPolygon) var WaterNavigation = null
# NOTE: Once implemented the Map_001.tscn can be removed

