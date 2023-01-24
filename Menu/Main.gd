extends Control

func _ready() -> void:
	$VBoxContainer/Start.grab_focus()

func _on_Start_pressed() -> void:
	get_tree().change_scene_to(Global.MyWorld)

func _on_Quit_pressed() -> void:
	get_tree().quit()
