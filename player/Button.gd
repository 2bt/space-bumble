extends Control

var input_event: InputEvent = null


func update_input_event(event: InputEvent) -> void:
	if input_event and not event:
		var e := InputEventAction.new()
		e.action = "fire"
		e.pressed = false
		Input.parse_input_event(e)
	input_event = event
	if input_event:
		var e := InputEventAction.new()
		e.action = "fire"
		e.pressed = true
		Input.parse_input_event(e)

func _exit_tree() -> void:
	update_input_event(null)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		if input_event and input_event.index == event.index:
			input_event = event
	if event is InputEventScreenTouch:
		if event.pressed and not input_event and get_rect().has_point(event.position):
			update_input_event(event)
		if not event.pressed and input_event and input_event.index == event.index:
			update_input_event(null)


func _process(_delta: float) -> void:
	queue_redraw()
func _draw() -> void:
	if input_event:
		draw_circle(input_event.position - position, 16, Color(1, 1, 1, 0.5))
