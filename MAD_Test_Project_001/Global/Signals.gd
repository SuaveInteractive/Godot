extends Node

# https://gdscript.com/signals-godot
# https://docs.godotengine.org/en/stable/getting_started/step_by_step/singletons_autoload.html
# https://www.reddit.com/r/godot/comments/6xtrdv/autoload_and_signals/
# https://github.com/godotengine/godot/issues/10991

signal NodeCreate(name, obj)

signal BuildStructure(build_Information)
