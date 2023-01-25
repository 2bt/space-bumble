extends CharacterBody2D

const SPEED = 400.0
var player: Node2D = null

func init(player_):
	player = player_
	position = player.position - Vector2(0, 20)

func _physics_process(delta: float) -> void:
	var c = move_and_collide(Vector2(0, -SPEED) * delta)
	if not c: return
	queue_free()
	$CollisionShape2D.disabled = true
	Global.world.make_explosion(c.get_position(), "small")
	var e = c.get_collider()
	if e.is_in_group("enemies"):
		e.hit()
		if e.life == 0:
			player.inc_score(e.SCORE)
