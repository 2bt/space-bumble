extends Enemy

const SCORE := 70
const SPEED := 40.0
var ang_vel := 0.0
var tick := 0.0

func _ready() -> void:
	life = 2

	# find random position
	var dir = Global.random.randi_range(0, 1)
	if dir == 0: dir = -1
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(
		global_position,
		global_position + Vector2(dir * 300, 0),
		[self],
		collision_mask)
	if result:
		global_position.x = Global.random.randf_range(global_position.x, result["position"].x)

	rotation += Global.random.randf_range(-0.6, 0.6)
	tick = Global.random.randf_range(0, 4)

#func _process(delta: float) -> void:
#	update()
#func _draw() -> void:
#	if $Left.is_colliding():
#		draw_circle(to_local($Left.get_collision_point()), 5, Color(1, 0, 0, 1))
#	if $Right.is_colliding():
#		draw_circle(to_local($Right.get_collision_point()), 5, Color(0, 1, 0, 1))

func _physics_process(delta: float) -> void:
	tick += delta

	var rot := sin(tick * 1.8)
	if 	$Middle.is_colliding():
		rot = 4 if position.x > Global.W / 2 else -4
	elif $Left.is_colliding():
		rot = -2
	elif $Right.is_colliding():
		rot = 2
	ang_vel = Global.step(rot, ang_vel, delta * 4)
	rotation += ang_vel * delta

	move_and_slide(Vector2(0, Global.world.SPEED) + Vector2(0, SPEED).rotated(rotation))
