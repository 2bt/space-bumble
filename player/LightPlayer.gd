extends CharacterBody2D

const SPEED := 180.0

func _ready() -> void:
	Input.connect("joy_connection_changed",Callable(self,"_on_joy_connection_changed"))

	if not 1 in Input.get_connected_joypads():
		$CollisionShape2D.disabled = true
		visible = false

func _on_joy_connection_changed(device_id: int, connected: bool) -> void:
	if device_id != 1: return
	if connected:
		$CollisionShape2D.disabled = false
		visible = true
	else:
		$CollisionShape2D.disabled = true
		visible = false

func hit() -> void:
	pass

func _physics_process(_delta):
	if not visible: return
	var d = Input.get_vector("light_left", "light_right", "light_up", "light_down")
	set_velocity(d * SPEED)
	move_and_slide()
