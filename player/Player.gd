class_name Player
extends CharacterBody2D

const SPEED := 130.0
const FIRE_DELAY := 0.25
const FIRE_POWER_COST := 0.5
const FIRE_POWER_MAX := 2.0

var score := 0
var fire_tick := 0.0
var fire_power := FIRE_POWER_MAX

func _ready() -> void:
	inc_score(0)

func inc_score(amount: int) -> void:
	score += amount
	$HUD/Score.text = str(score)

func update_fire_power_bar() -> void:
	var x = inverse_lerp(0, FIRE_POWER_MAX, fire_power)
	var h = $HUD/FirePowerBG.size.y
	$HUD/FirePower.size.y = floor(h * x)

func hit() -> void:
	Global.world.make_explosion(position)

	$CollisionPolygon2D.disabled = true
	visible = false
	$HUD/FirePower.visible = false

	# switch to main menu
	await get_tree().create_timer(1).timeout
	SceneTransition.change_scene_to_packed(Global.MainMenuScene)

func _physics_process(delta):
	if not visible: return

	var d := Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	set_velocity(d * SPEED)
	move_and_slide()
	for i in range(get_slide_collision_count()):
		var c = get_slide_collision(i)
		if c.get_collider().is_in_group("enemies"):
			c.get_collider().hit()
			hit()

	# squised
	if test_move(transform, Vector2.ZERO): hit()

	fire_tick += delta
	fire_power = min(fire_power + delta, FIRE_POWER_MAX)
	if Input.is_action_pressed("fire") and fire_tick >= FIRE_DELAY and fire_power >= FIRE_POWER_COST:
		fire_tick = 0
		fire_power -= FIRE_POWER_COST
		var b = preload("PlayerBullet.tscn").instantiate()
		b.init(self)
		Global.world.bullets.add_child(b)

	update_fire_power_bar()
