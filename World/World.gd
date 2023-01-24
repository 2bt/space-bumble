extends Node2D

const SPEED := 15.0
const MARGIN_Y := 100

onready var walls := $Walls
onready var bullets := $Bullets
onready var enemies := $Enemies
onready var particles := $Particles


func make_explosion(pos: Vector2, size = "normal") -> void:
	var e = preload("res://Particles/Explosion.tscn").instance()
	e.init(pos, size)
	particles.add_child(e)


class WallSet:
	var offset := 0.0
	var scroll := 0.0
	var walls := []
	var align_right := false
	var prev_w := 0
	func _init(align_right_):
		align_right = align_right_
	func scroll(amount):
		for w in walls: w.position.y += amount
		offset += amount
		scroll += amount
		# add new walls
		while offset > 0:
			var maxw = min(5, scroll / 100)
			var w = 1 + (Global.random.randi_range(0, maxw) +
						 Global.random.randi_range(0, maxw - 3))
			var w_diff = abs(prev_w - w)
			prev_w = w
			var h = Global.random.randi_range(1, 6)
			h = max(h, floor((w_diff + 5) / 2))
			w *= 20
			h *= 20
			offset -= h
			var wall = preload("res://World/Wall.tscn").instance()
			var x = Global.W - w if self.align_right else 0
			wall.init(x, offset - MARGIN_Y, w, h)
			walls.append(wall)
			Global.world.walls.add_child(wall)
		# remove old walls
		while walls and walls[0].position.y > Global.H + MARGIN_Y:
			walls.pop_front().queue_free()

var left_wall := WallSet.new(false)
var right_wall := WallSet.new(true)

var enemy_scenes := []
var enemy_weights := [0]

func add_enemy_scene(weight: float, scene: PackedScene) -> void:
	enemy_scenes.append(scene)
	enemy_weights.append(enemy_weights[-1] + weight)

func _ready() -> void:
	add_enemy_scene(3, preload("res://Enemies/UfoEnemy.tscn"))
	add_enemy_scene(5, preload("res://Enemies/RedEnemy.tscn"))
	add_enemy_scene(1, preload("res://Enemies/TankEnemy.tscn"))

	Global.world = self
	left_wall.scroll(Global.H + MARGIN_Y)
	right_wall.scroll(Global.H + MARGIN_Y)

#	var E = preload("res://Enemies/TankEnemy.tscn")
#	var e = E.instance()
#	e.init(Vector2(300, 50))
#	enemies.add_child(e)


var tick := 0.0
var time := 0.0



func _physics_process(delta: float) -> void:
	left_wall.scroll(delta * SPEED)
	right_wall.scroll(delta * SPEED)

	# darkness
	time += delta

	# spawn enemies
	tick += delta
	if tick > 0:
		tick -= Global.random.randf_range(0.5, 3)

		var w: float = Global.random.randf_range(0, enemy_weights[-1])
		var i := enemy_weights.bsearch(w) - 1
		var e = enemy_scenes[i].instance()
		e.init(Vector2(Global.W / 2, Global.random.randi_range(-50, -30)))
		enemies.add_child(e)


func _process(_delta: float) -> void:
	$Shadow.material.set_shader_param("time", time)
	$Shadow.material.set_shader_param("screen_size", Vector2(Global.W, Global.H))
	$Shadow.material.set_shader_param("player_pos", $Player.position)
	if $LightPlayer.visible:
		$Shadow.material.set_shader_param("light_pos", $LightPlayer.position)
	else:
		$Shadow.material.set_shader_param("light_pos", Vector2(-1000, 0))


func _on_ViewArea_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		body.fire_enabled = true

func _on_ViewArea_body_exited(body: Node) -> void:
	if body.is_in_group("player_bullets") or body.is_in_group("enemy_bullets"):
		body.queue_free()
	if body.is_in_group("enemies"):
		body.fire_enabled = false

func _on_PaddedViewArea_body_exited(body: Node) -> void:
	body.queue_free()
