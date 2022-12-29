extends Node

# https://gdscript.com/signals-godot
# https://docs.godotengine.org/en/stable/getting_started/step_by_step/singletons_autoload.html
# https://www.reddit.com/r/godot/comments/6xtrdv/autoload_and_signals/
# https://github.com/godotengine/godot/issues/10991

signal NodeCreate(name, obj)



signal UnitSelected(unit)

"""
Player Actions
"""
signal PlayerBuildStructure(build_Information)

"""
Emitted when one or more unit is selected
"""
signal UnitsSelected(units)

"""
Game State Changes
"""
#signal CountryControlChange(country, oldControl, newControl)
#signal CountryFinanceChange(country, oldFinance, newFinance)
signal SetCountryActive(country, active)
signal CountryWins(country)

"""
Game Actions
"""
signal EndGameAction()

