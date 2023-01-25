extends Control


func _ready() -> void:
	for i in 10:
		var score := Global.scores[i]
		var label: Label = $Scores.get_child(-1 - i)
		label.text = str(score)
		if i == Global.last_score_index:
			label.label_settings = label.label_settings.duplicate()
			label.label_settings.font_color = Color(0, 1, 1, 1)
			$Numbers.get_child(-1 - i).label_settings = label.label_settings

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		SceneTransition.change_scene_to_packed(Global.MainMenuScene)

func _process(_delta: float) -> void:
	if get_viewport().gui_disable_input: return
	if Input.is_action_pressed("ui_accept") or Input.is_action_pressed("ui_cancel"):
		SceneTransition.change_scene_to_packed(Global.MainMenuScene)
