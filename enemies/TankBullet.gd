extends CharacterBody2D


const SPEED := 130.0

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	var c = move_and_collide(
		Vector2(0, -SPEED).rotated(rotation) * delta +
		Vector2(0, Global.world.SPEED * delta))
	if not c: return
	queue_free()
	Global.world.make_explosion(c.get_position(), "small")
	if c.get_collider().is_in_group("players"):
		c.get_collider().hit()
