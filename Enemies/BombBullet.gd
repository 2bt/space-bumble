extends KinematicBody2D

const ACCEL := 300.0
var vel := 70.0

func _physics_process(delta: float) -> void:
	vel += delta * ACCEL
	var c = move_and_collide(Vector2(0, vel) * delta)
	if not c: return
	queue_free()
	Global.world.make_explosion(c.position, "small")
	if c.collider.is_in_group("players"):
		c.collider.hit()
