class_name Enemy
extends CharacterBody2D

var fire_enabled := false
var life := 1

func init(pos: Vector2) -> void:
	position = pos


func hit() -> void:
	life -= 1
	if life == 0:
		queue_free()
		Global.world.make_explosion(position)
