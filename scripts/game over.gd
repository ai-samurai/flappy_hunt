extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("PanelContainer/MarginContainer/rows/VBoxContainer/restartButton").grab_focus()

func _on_restartButton_pressed():
	get_tree().change_scene("res://scenes/main.tscn")

func _on_quitButton_pressed():
	get_tree().quit()
