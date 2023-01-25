extends Node2D

const SPEED := 15.0
const VEL := Vector2(0.0, SPEED)
const MARGIN_Y := 100

@onready var walls := $Walls
@onready var bullets := $Bullets
@onready var enemies := $Enemies
@onready var particles := $Particles


func make_explosion(pos: Vector2, size = "normal") -> void:
	var e = preload("res://particles/Explosion.tscn").instantiate()
	e.init(pos, size)
	particles.add_child(e)


class WallSet:
	var offset := 0.0
	var tick := 0.0
	var walls := []
	var align_right := false
	var prev_w := 0
	func _init(align_right_):
		align_right = align_right_
	func scroll(amount):
		for w in walls: w.position.y += amount
		offset += amount
		tick += amount
		# add new walls
		while offset > 0:
			var maxw = min(5, tick / 100)
			var w = 1
			w += Global.random.randi_range(0, maxw)
			w += Global.random.randi_range(0, maxw - 3)
			var w_diff = abs(prev_w - w)
			prev_w = w
			var h = Global.random.randi_range(1, 6)
			h = max(h, floor((w_diff + 5) / 2))
			w *= 20
			h *= 20
			offset -= h
			var wall = preload("Wall.tscn").instantiate()
			var x = Global.W - w if self.align_right else 0
			wall.init(x, offset - MARGIN_Y, w, h)
			walls.append(wall)
			Global.world.walls.add_child(wall)
		# remove_at old walls
		while walls and walls[0].position.y > Global.H + MARGIN_Y:
			walls.pop_front().queue_free()

var left_wall := WallSet.new(false)
var right_wall := WallSet.new(true)

var enemy_scenes: Array[PackedScene] = []
var enemy_weights := [0.0]

func add_enemy_scene(weight: float, scene: PackedScene) -> void:
	enemy_scenes.append(scene)
	enemy_weights.append(enemy_weights[-1] + weight)

func _ready() -> void:
	add_enemy_scene(3.0, preload("res://enemies/UfoEnemy.tscn"))
	add_enemy_scene(5.0, preload("res://enemies/RedEnemy.tscn"))
	add_enemy_scene(4.0, preload("res://enemies/TankEnemy.tscn"))

	Global.world = self
	left_wall.scroll(Global.H + MARGIN_Y)
	right_wall.scroll(Global.H + MARGIN_Y)


var time := 0.0
var tick := -2.0 # wait before first spawn

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
		var e = enemy_scenes[i].instantiate()
		e.init(Vector2(Global.W * 0.5, -40.0))
		enemies.add_child(e)


func _process(_delta: float) -> void:
	if $Shadow.visible:
		$Shadow.material.set_shader_parameter("time", time)
		$Shadow.material.set_shader_parameter("screen_size", Vector2(Global.W, Global.H))
		$Shadow.material.set_shader_parameter("player_pos", $Player.position)
		if $LightPlayer.visible:
			$Shadow.material.set_shader_parameter("light_pos", $LightPlayer.position)
		else:
			$Shadow.material.set_shader_parameter("light_pos", Vector2(-1000, 0))


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
