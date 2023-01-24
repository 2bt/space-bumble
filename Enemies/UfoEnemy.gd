extends Enemy

const SPEED := 70
const SCORE := 100
var tick := 0.0
var time := 0.0
var dir := 1

func _ready() -> void:
	life = 3
	if Global.random.randi_range(0, 1) == 0: dir = 1
	tick = Global.random.randf_range(0, 2)

func _physics_process(delta: float) -> void:
	time += delta
	if fire_enabled:
		tick -= delta
		if tick < 0:
			tick = Global.random.randf_range(1, 4)
			var b = preload("res://Enemies/BombBullet.tscn").instance()
			b.position = position + Vector2(dir * 5, 10)
			Global.world.bullets.add_child(b)

	move_and_slide(Vector2(dir * SPEED, Global.world.SPEED + sin(time * 12) * 20))
	for i in range(get_slide_count()):
		var c := get_slide_collision(i)
		if c.collider.is_in_group("walls") and abs(c.normal.x) > 0.8:
			dir *= -1
			break
