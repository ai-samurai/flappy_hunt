extends Node2D

onready var arrow = load("res://scenes/arrow.tscn")

var screen_size
var score = 0
var time = 0
var global
var test = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if test == true:
		$archer.queue_free()
		$archer2.queue_free()
	global = get_tree().root.get_child(0)
	screen_size = get_viewport_rect().size
	global.screen_size = screen_size
	$archer.connect("shot_fired" , self, "_shot_fired")
	$archer2.connect("shot_fired", self, "_shot_fired")
	$archer.connect("game_over" , self, "_on_game_over")
	get_signal_list()

func _shot_fired(node):
	var pos = node.position
	pos.y -= 30
	var shot = arrow.instance()
	shot.position = pos
	shot.dir = node.dir
	shot.x_speed = node.archer_speed / 2
	add_child(shot)
	
func _on_game_over(node):
	get_tree().change_scene("res://scenes/game over.tscn")

func _process(delta):
	time += delta 
	if $bird.position.y > screen_size.y - 10: 
		global._game_over()
	elif $bird.position.y < -100: 
		global._game_over()
	
	
func _input(event):
	if Input.is_action_just_pressed("ui_cancel"): 
		$pause.get_node("pause_scene").res_button.grab_focus()
		$pause.get_node("pause_scene").visible = not $pause.get_node("pause_scene").visible 
		get_tree().paused = not get_tree().paused

