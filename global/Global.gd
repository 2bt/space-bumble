extends Node

const MainMenuScene   := preload("res://menu/Main.tscn")
const HighscoresScene := preload("res://menu/Highscores.tscn")
const WorldScene      := preload("res://world/World.tscn")

var H: int = ProjectSettings.get_setting("display/window/size/height")
var W: int = ProjectSettings.get_setting("display/window/size/width")
var random := RandomNumberGenerator.new()
var world = null

func step(val: float, dst: float, step: float):
	if val < dst: return min(val + step, dst)
	return max(val - step, dst)

const HIGHSCORES_PATH = "user://highscores.txt"

func _ready() -> void:
	random.randomize()
