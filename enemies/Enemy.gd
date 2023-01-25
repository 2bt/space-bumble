extends CharacterBody2D
class_name Enemy

var fire_enabled := false
var life := 1

func init(pos: Vector2) -> void:
	position = pos


func hit() -> void:
	life -= 1
	if life == 0:
		queue_free()
		Global.world.make_explosion(position)
