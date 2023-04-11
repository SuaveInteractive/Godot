extends GutTest

var rid : RID

func before_all():		
	rid = Navigation2DServer.agent_create()
	
func after_all():
	assert_no_new_orphans()
	Navigation2DServer.free_rid(rid)

func test_serialize_RID() -> void:
	var processedRID = ScriptRecorder._processArgument(TYPE_RID, rid)
	assert_not_null(processedRID)

