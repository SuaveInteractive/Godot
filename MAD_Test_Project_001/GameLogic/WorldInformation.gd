extends Resource
class_name WorldInformation

const CountryDataResource = preload("res://GameLogic/CountryData.gd")
const Country1Data = preload("res://Country_1.tres")

enum AllianceStatus {ALLIANCESTATUS_ALLIED, ALLIANCESTATUS_NOTALLIED, ALLIANCESTATUS_ATWAR}

export(int) var NumberOfCountries = 0
export(Array, AllianceStatus) var CountriesAllianceStatus
export(Array, Resource) var Countries
# export(Array, Array, Resource) var CountryBoarders # https://docs.godotengine.org/en/stable/classes/class_polygon2d.html

func _init():
	NumberOfCountries = 2
	
	""" Create the Countries """
	Countries.resize(NumberOfCountries)
	Countries[0] = Country1Data
	#Countries[1] = CountryDataResource.new() 
	
	"""	Set up the alliance status for all countries """	
	CountriesAllianceStatus.resize(NumberOfCountries*NumberOfCountries)
	
	for i in NumberOfCountries:
		for j in NumberOfCountries:
			var index = i * NumberOfCountries + j
			CountriesAllianceStatus[index] = AllianceStatus.ALLIANCESTATUS_NOTALLIED
