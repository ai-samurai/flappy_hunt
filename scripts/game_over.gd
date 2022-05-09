extends Control

var resume_cooldown
var res_button
var global

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_tree().root.get_child(0)
	update_score_labels()
	res_button = get_node("PanelContainer/MarginContainer/VBoxContainer/Buttons/Restart")
	res_button.grab_focus()
	

func _on_Restart_pressed():
	get_tree().reload_current_scene()


func _on_Quit_pressed():
	get_tree().quit()


func update_score_labels():
	get_node("PanelContainer/MarginContainer/VBoxContainer/Scores/score").text = "Score: " + str(global.score)
	get_node("PanelContainer/MarginContainer/VBoxContainer/Scores/highscore").text = "Highscore: " + str(global.high_score)
