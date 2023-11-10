extends Resource
class_name IntelligenceInformation

"""Standard Intelligence Info - Should have valid data for every Intel"""
export(String) var Type
export(Vector2) var Position

"""Following data is not guarenteed to exist"""
export(NodePath) var TrackingNodePath
export(NodePath) var DetectorNodePath
