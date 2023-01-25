extends Node2D

var size := "normal"
var radius := 5.0
var alpha := 1.0


func init(pos: Vector2, size_ = "normal") -> void:
	size = size_
	global_position = pos

func _ready() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	match size:
		"small":
			tween.tween_property(self, "radius", 0.0, 0.1)
			tween.tween_callback(Callable(self,"queue_free"))
			create_tween().set_ease(Tween.EASE_IN).tween_property(self, "alpha", 0.0, 0.1)
		"normal":
			tween.tween_property(self, "radius", 15.0, 0.1)
			tween.tween_property(self, "radius", 0.0, 0.1)
			tween.tween_property(self, "radius", 30.0, 0.05)
			tween.tween_property(self, "radius", 0.0, 0.2)
			tween.tween_callback(Callable(self,"queue_free"))
			create_tween().set_ease(Tween.EASE_IN).tween_property(self, "alpha", 0.0, 0.4)

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color(1, 1, 1, alpha))
