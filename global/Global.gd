extends Node

const MainMenuScene   := preload("res://menu/Main.tscn")
const HighscoresScene := preload("res://menu/Highscores.tscn")
const WorldScene      := preload("res://world/World.tscn")

var H: int = ProjectSettings.get_setting("display/window/size/height")
var W: int = ProjectSettings.get_setting("display/window/size/width")
var random := RandomNumberGenerator.new()
var world: Node2D = null

func step(val: float, dst: float, step: float):
	if val < dst: return min(val + step, dst)
	return max(val - step, dst)

const HIGHSCORES_PATH = "user://highscores.txt"

var scores := [1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000]
var last_score_index := -1

func add_new_score(score: int) -> bool:
	if score < scores.front():
		last_score_index = -1
		return false
	last_score_index = scores.bsearch(score, false)
	scores.insert(last_score_index, score)
	scores.pop_front()
	last_score_index -= 1

	var f := FileAccess.open(HIGHSCORES_PATH, FileAccess.WRITE)
	f.store_string(JSON.stringify(scores))

	return true


func _ready() -> void:
	random.randomize()

	# read scores
	if FileAccess.file_exists(HIGHSCORES_PATH):
		var f := FileAccess.open(HIGHSCORES_PATH, FileAccess.READ)
		scores = JSON.parse_string(f.get_as_text())
