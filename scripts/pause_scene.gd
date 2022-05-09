extends Control

var resume_cooldown
var res_button
var main
var global

# Called when the node enters the scene tree for the first time.
func _ready():
	main = get_parent().get_parent()
	global = get_node("/root/Global")
	resume_cooldown = Timer.new()
	resume_cooldown.set_one_shot(true)
	resume_cooldown.set_wait_time(0.5)
	resume_cooldown.connect("timeout", self, '_on_resume_cooldown')
	add_child(resume_cooldown)
	res_button = get_node("PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/resume")
	res_button.grab_focus()
	update_score_labels()


func _on_resume_pressed():
	visible = not visible
	resume_cooldown.start()


func _on_resume_cooldown():
	get_tree().paused = not get_tree().paused


func _input(event):
	if event.is_action_pressed("ui_cancel") and get_tree().paused == true:
		visible = not visible
		resume_cooldown.start()


func _on_restart_pressed():
	get_tree().paused = not get_tree().paused
	visible = not visible
	get_tree().change_scene("res://scenes/main.tscn")


func update_score_labels():
	get_node("PanelContainer/MarginContainer/VBoxContainer/scores/score").text = "Score: " + str(global.score) 
	get_node("PanelContainer/MarginContainer/VBoxContainer/scores/highcore").text = "Highscore: " + str(global.high_score)


func _on_quit_pressed():
	get_tree().quit()
