extends CanvasLayer

var blend := -1.0

func change_scene_to(scene: PackedScene) -> void:
	get_viewport().set_disable_input(true)
	blend = -1.0;
	var tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "blend", 0.0, 0.6)
	tween.tween_callback(get_tree(), "change_scene_to", [scene])
	tween.tween_property(self, "blend", 1.0, 0.6)
	tween.tween_callback(get_viewport(), "set_disable_input", [false])

func _process(_delta: float) -> void:
	$Blend.material.set_shader_param("blend", blend)
