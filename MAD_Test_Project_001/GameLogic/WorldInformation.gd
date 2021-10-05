extends Resource
class_name WorldInformation

enum AllianceStatus {ALLIANCESTATUS_ALLIED, ALLIANCESTATUS_NOTALLIED, ALLIANCESTATUS_ATWAR}

export(int) var NumberOfCountries = 0
export(Array, AllianceStatus) var CountriesAllianceStatus
export(Array, Array, Resource) var CountryBoarders # https://docs.godotengine.org/en/stable/classes/class_polygon2d.html

func _init():
	NumberOfCountries = 2
	
	CountriesAllianceStatus.resize(NumberOfCountries*NumberOfCountries)
	
	for i in NumberOfCountries:
		for j in NumberOfCountries:
			var index = i * NumberOfCountries + j
			CountriesAllianceStatus[index] = AllianceStatus.ALLIANCESTATUS_NOTALLIED
