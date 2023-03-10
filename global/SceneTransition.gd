extends CanvasLayer

var blend := -1.0

func change_scene_to_packed(scene: PackedScene) -> void:
	get_viewport().gui_disable_input = true
	blend = -1.0
	var tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "blend", 0.0, 0.6)
	tween.tween_callback(Callable(get_tree(),"change_scene_to_packed").bind(scene))
	tween.tween_property(self, "blend", 1.0, 0.6)
	tween.tween_callback(Callable(get_viewport(),"set_disable_input").bind(false))

func _process(_delta: float) -> void:
	$Blend.material.set_shader_parameter("blend", blend)
