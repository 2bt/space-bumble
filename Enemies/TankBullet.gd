extends KinematicBody2D


const SPEED := 100.0

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	var c = move_and_collide(Vector2(0, -SPEED).rotated(rotation) * delta +
							 Vector2(0, Global.world.SPEED * delta))
	if not c: return
	queue_free()
	Global.world.make_explosion(c.position, "small")
	if c.collider.is_in_group("players"):
		c.collider.hit()
