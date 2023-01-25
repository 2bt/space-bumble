extends Control

func _ready() -> void:
	$VBoxContainer/Start.grab_focus()

func _on_Start_pressed() -> void:
	SceneTransition.change_scene_to(Global.WorldScene)

func _on_Highscores_pressed() -> void:
	SceneTransition.change_scene_to(Global.HighscoresScene)


func _on_Quit_pressed() -> void:
	get_tree().quit()
