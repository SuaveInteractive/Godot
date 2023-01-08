extends Viewport
class_name DetectNode

export (Array, Shape2D) var DetectionShapes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for shape2D in DetectionShapes:
		addCollisionShape(shape2D)

func _process(delta):
	$DetectorArea.position = get_parent().position
	
func addCollisionShape(shape2D : Shape2D) -> void:
	var newCollisionShape = CollisionShape2D.new()
	#var pos = get_parent().position
	#newCollisionShape.position = get_parent().position
	newCollisionShape.set_shape(shape2D)
	$DetectorArea.add_child(newCollisionShape)



