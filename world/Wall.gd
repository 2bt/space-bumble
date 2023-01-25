extends CharacterBody2D

func get_class(): return "Wall"

func init(x: float, y: float, w: float, h: float) -> void:
	position.x = x
	position.y = y
	$ColorRect.size.x = w
	$ColorRect.size.y = h
	var o = Vector2(w / 2, h / 2)
	$CollisionShape2D.transform = Transform2D(0, o)
	$CollisionShape2D.shape = RectangleShape2D.new()
	$CollisionShape2D.shape.extents = o
