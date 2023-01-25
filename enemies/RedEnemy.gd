extends Enemy

const SCORE := 70
const SPEED := 40.0
var ang_vel := 0.0
var tick := 0.0

func _ready() -> void:
	life = 2

	rotation += Global.random.randf_range(-0.6, 0.6)

	# find random position
	var dir := Global.random.randi_range(0, 1)
	if dir == 0: dir = -1
	var space_state := get_world_2d().direct_space_state
	var params := PhysicsRayQueryParameters2D.create(
		global_position,
		global_position + Vector2(dir * 300.0, 0.0),
		collision_mask)
	var result := space_state.intersect_ray(params)
	if result:
		global_position.x = Global.random.randf_range(global_position.x, result["position"].x)

	tick = Global.random.randf_range(0, 4)


func _physics_process(delta: float) -> void:
	tick += delta

	var rot := sin(tick * 1.8)
	if 	$Middle.is_colliding():
		rot = 4.0 if position.x > Global.W * 0.5 else -4.0
	elif $Left.is_colliding():
		rot = -2.0
	elif $Right.is_colliding():
		rot = 2.0
	ang_vel = Global.step(rot, ang_vel, delta * 4.0)
	rotation += ang_vel * delta

	set_velocity(Global.world.VEL + Vector2(0, SPEED).rotated(rotation))
	move_and_slide()
