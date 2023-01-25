extends AnimatableBody2D

func get_class(): return "Wall"

func init(x: float, y: float, w: float, h: float) -> void:
	position.x = x
	position.y = y
	$Rect.size.x = w
	$Rect.size.y = h
	var o = Vector2(w / 2, h / 2)
	$Shape.transform = Transform2D(0, o)
	$Shape.shape = RectangleShape2D.new()
	$Shape.shape.extents = o
