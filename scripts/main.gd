extends Node2D

onready var arrow = load("res://scenes/arrow.tscn")

var screen_size
var score = 0
var time = 0
var previous_fps_drop_time = 0
var time_diff = 0
var global
var test = false
var fps

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	#$left_bar.get_node("Sprite").set_material(null)
	#$right_bar.get_node("Sprite").set_material(null)
	if test == true:
		pass
	global = get_tree().root.get_child(0)
	screen_size = get_viewport_rect().size
	global.screen_size = screen_size
	global.score = 0
	$archer.connect("shot_fired" , self, "_shot_fired")
	$archer2.connect("shot_fired", self, "_shot_fired")
	$archer.connect("game_over" , self, "_on_game_over")
	get_signal_list()
	# set archer positions
	$archer.position = Vector2(50, screen_size.y - 40)
	$archer2.position = Vector2(screen_size.x - 110, screen_size.y - 40)
	$archer2.get_node("Sprite").set_flip_h(true)
	

func _shot_fired(node):
	var pos = node.position
	pos.y -= 30
	var shot = arrow.instance()
	shot.position = pos
	shot.dir = node.dir
	shot.x_speed = node.archer_speed / 2
	add_child(shot)
	
func _game_over():
	$CanvasLayer.get_node("game_over").update_score_labels()
	$CanvasLayer.get_node("game_over").res_button.grab_focus()
	$CanvasLayer.get_node("game_over").visible = not $CanvasLayer.get_node("game_over").visible 
	get_tree().paused = not get_tree().paused

func _process(delta):
	boost_display($bird.remaining_boosts)
	fps = Engine.get_frames_per_second()
	$Label.text = "S: " + str(global.score)
	if get_tree().paused != true:
		$pause.get_node("pause_scene").visible = false
	time += delta 
#	if $bird.position.y > screen_size.y + 50: 
#		_game_over()
#	elif $bird.position.y < -100: 
#		_game_over()
	
func _input(event):
	if Input.is_action_just_pressed("ui_cancel"): 
		$pause.get_node("pause_scene").update_score_labels()
		$pause.get_node("pause_scene").res_button.grab_focus()
		$pause.get_node("pause_scene").visible = not $pause.get_node("pause_scene").visible 
		get_tree().paused = not get_tree().paused
#	if Input.is_action_just_pressed("ui_cancel"): 
	if Input.is_mouse_button_pressed(1) and test == true:
		print(get_global_mouse_position())	

func _on_MobileControls_left_swipe(start_postion):
	$bird.left_move()
	
func _on_MobileControls_right_swipe(start_position):
	$bird.right_move()

func _on_MobileControls_jump(start_position):
	$bird.jump()

func boost_display(n):
	for count in $boosts.get_children():
		if int(count.name) > n:
			count.visible = false
		if int(count.name) <= n:
			count.visible = true
