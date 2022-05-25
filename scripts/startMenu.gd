extends CanvasLayer

var global
var screen = Sprite.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_tree().root.get_child(0)
	get_node("PanelContainer/MarginContainer/rows/VBoxContainer/startButton").grab_focus()
	$PanelContainer/MarginContainer/rows/VBoxContainer2/high_score.text = "High Score: " + str(global.high_score)

func _on_startButton_pressed():
	global.score = 0
	get_tree().change_scene("res://scenes/main.tscn")

func _on_quitButton_pressed():
	get_tree().quit()
