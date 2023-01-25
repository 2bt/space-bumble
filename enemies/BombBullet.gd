extends CharacterBody2D

const ACCEL := 250.0
var vel := 60.0

func _physics_process(delta: float) -> void:
	vel += delta * ACCEL
	var c = move_and_collide(Vector2(0, vel) * delta)
	if not c: return
	queue_free()
	Global.world.make_explosion(c.get_position(), "small")
	if c.get_collider().is_in_group("players"):
		c.get_collider().hit()
