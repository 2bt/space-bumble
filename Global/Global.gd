extends Node

const MainMenu := preload("res://Menu/Main.tscn")
const MyWorld := preload("res://World/World.tscn")


var H: int = ProjectSettings.get_setting("display/window/size/height")
var W: int = ProjectSettings.get_setting("display/window/size/width")
var random := RandomNumberGenerator.new()
var world = null

static func step(val: float, dst: float, step: float):
	if val < dst: return min(val + step, dst)
	return max(val - step, dst)

func _ready() -> void:
	random.randomize()
