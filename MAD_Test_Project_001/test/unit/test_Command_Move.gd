extends GutTest

var rid : RID

var SubmarineScene = preload("res://GameEntities/Submarine/Submarine.tscn")
var SubmarineObject = null
	
func before_all():		
	rid = Navigation2DServer.agent_create()
	RIDMapper.addMapping("TestRID", rid)
	
func after_all():
	assert_no_new_orphans()
	Navigation2DServer.free_rid(rid)

func before_each():
	SubmarineObject = add_child_autofree(SubmarineScene.instance())

func test_execution() -> void:
	GameCommands.MoveCommand.MapName = "TestRID"
	GameCommands.MoveCommand.Position_To = Vector2(100, 100)
	GameCommands.MoveCommand.Selected_Units = [SubmarineObject]			
	assert_true(GameCommands.MoveCommand.execute())

func test_invalid_RID() -> void:
	GameCommands.MoveCommand.MapName = "InvalidRID"
	GameCommands.MoveCommand.Position_To = Vector2(100, 100)
	GameCommands.MoveCommand.Selected_Units = [SubmarineObject]			
	assert_false(GameCommands.MoveCommand.execute())
