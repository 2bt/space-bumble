extends Control

var input_event: InputEvent = null
var dx := 0.0
var dy := 0.0

func clamp_vector2(v: Vector2, minv: Vector2, maxv: Vector2) -> Vector2:
	return Vector2(clamp(v.x, minv.x, maxv.x), clamp(v.y, minv.y, maxv.y))


func update_dx(v: float) -> void:
	v = clamp(v, -1, 1)
	if sign(v) != sign(dx):
		if dx != 0:
			var e := InputEventAction.new()
			e.action = "right" if dx > 0.0 else "left"
			e.pressed = false
			Input.parse_input_event(e)
	dx = v
	if dx != 0:
		var e := InputEventAction.new()
		e.action = "right" if dx > 0.0 else "left"
		e.pressed = true
		e.strength = abs(dx)
		Input.parse_input_event(e)

func update_dy(v: float) -> void:
	v = clamp(v, -1, 1)
	if sign(v) != sign(dy):
		if dy != 0:
			var e := InputEventAction.new()
			e.action = "down" if dy > 0.0 else "up"
			e.pressed = false
			Input.parse_input_event(e)
	dy = v
	if dy != 0:
		var e := InputEventAction.new()
		e.action = "down" if dy > 0.0 else "up"
		e.pressed = true
		e.strength = abs(dy)
		Input.parse_input_event(e)


func update_input_event(event: InputEvent) -> void:
	if not event:
		$MoveRect.visible = false
	elif event and not input_event:
		$MoveRect.position = event.position - $MoveRect.size / 2
		$MoveRect.visible = true

	input_event = event
	if input_event:
		input_event.position = clamp_vector2(
			input_event.position,
			$MoveRect.position,
			$MoveRect.position + $MoveRect.size)

		var p = input_event.position - $MoveRect.position
		p = clamp_vector2(p, Vector2.ZERO, $MoveRect.size)
		update_dx(inverse_lerp($MoveRect.size.x * 0.5, $MoveRect.size.x, p.x))
		update_dy(inverse_lerp($MoveRect.size.y * 0.5, $MoveRect.size.y, p.y))
	else:
		update_dx(0)
		update_dy(0)

func _exit_tree() -> void:
	update_input_event(null)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		if input_event and input_event.index == event.index:
			update_input_event(event)
	if event is InputEventScreenTouch:
		if event.pressed and not input_event and get_rect().has_point(event.position):
			update_input_event(event)
		if not event.pressed and input_event and input_event.index == event.index:
			update_input_event(null)


func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if input_event:
		draw_circle(input_event.position, 16, Color(1, 1, 1, 0.5))
