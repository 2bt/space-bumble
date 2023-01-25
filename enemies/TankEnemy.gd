extends Enemy

const SCORE := 120
const SPEED := 25.0
var dir := -1
var dst_rot := 0.0
var rot := 0.0
var tick := 0.0

func _ready() -> void:
	life = 2
	if Global.random.randi_range(0, 1): dir = 1
	rotation_degrees = 90 * dir
	move_and_collide(Vector2(-Global.W * dir, 0))
	rot = rotation_degrees
	dst_rot = rot
	tick = Global.random.randf_range(0, 3)

func _physics_process(delta: float) -> void:
	if fire_enabled:
		tick -= delta
		if tick <= 0:
			tick = Global.random.randf_range(2, 5)
			# shoot
			var b = preload("TankBullet.tscn").instantiate()
			b.position = position + Vector2(0, -18).rotated(rotation)
			b.rotation = rotation
			Global.world.bullets.add_child(b)
			# turn around
			if abs(rot - dst_rot) < 0.1 and Global.random.randi_range(0, 2) == 0:
				dir *= -1

	var front := $Right if dir == 1 else $Left
	var down := $RightDown if dir == 1 else $LeftDown

	var speed := SPEED
	if abs(rot - dst_rot) > 0.1:
		rot = Global.step(rot, dst_rot, delta * SPEED * 4.0)
		rotation_degrees = rot
		speed *= 0.75
	elif front.is_colliding(): dst_rot -= 90 * dir
	elif not down.is_colliding(): dst_rot += 90 * dir

	set_velocity(Vector2(dir * speed, speed).rotated(rotation) + Vector2(0, Global.world.SPEED))
	move_and_slide()
