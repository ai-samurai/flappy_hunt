extends Control

var resume_cooldown
var res_button

# Called when the node enters the scene tree for the first time.
func _ready():
	resume_cooldown = Timer.new()
	resume_cooldown.set_one_shot(true)
	resume_cooldown.set_wait_time(0.2)
	resume_cooldown.connect("timeout", self, '_on_resume_cooldown')
	add_child(resume_cooldown)
	res_button = get_node("PanelContainer/MarginContainer/rows/VBoxContainer/resume")
	res_button.grab_focus()
	

func _on_restartButton_pressed():
	get_tree().paused = not get_tree().paused
	visible = not visible
	get_tree().change_scene("res://scenes/main.tscn")

func _on_quitButton_pressed():
	get_tree().quit()

func _on_resume_pressed():
	visible = not visible
	resume_cooldown.start()

func _on_resume_cooldown():
	get_tree().paused = not get_tree().paused
	
func _input(event):
	if event.is_action_pressed("ui_cancel") and get_tree().paused == true:
		visible = not visible
		resume_cooldown.start()

	
	
