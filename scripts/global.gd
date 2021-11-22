extends Node

var score = 0
var high_score = 0
var screen_size

func _ready():
	score = 0

func _process(delta):
	if score > high_score:
		high_score = score

func _game_over():
	get_tree().paused = true
	#yield(get_tree().create_timer(1.0), "timeout")
	#get_tree().paused = false
	#get_tree().change_scene("res://scenes/game over.tscn")


func freeze_frame(timeScale, duration):
	print("freeze_frame entered")
	Engine.time_scale = timeScale
	yield(get_tree().create_timer(timeScale * duration), "timeout")
	Engine.time_scale = 1.0


