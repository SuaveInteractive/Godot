extends Node

func isPlayerUnit(selection) -> bool:
	for country in get_children():
		if country.Player:
			for countryNode in country.get_children():
				if countryNode.get_node("Selection") == selection:
					return true
	return false

