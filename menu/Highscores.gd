extends Control


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	if get_viewport().gui_disable_input: return
	if Input.is_action_pressed("ui_accept") or Input.is_action_pressed("ui_cancel"):
		SceneTransition.change_scene_to_packed(Global.MainMenuScene)
