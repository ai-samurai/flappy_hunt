extends Node2D

onready var arrow = load("res://scenes/arrow.tscn")
onready var ScorePop = load("res://scenes/ScorePop.tscn")

var screen_size
var score = 0
var time = 0
var previous_fps_drop_time = 0
var time_diff = 0
var global
var fps
var symbol_hit_bool = false
var symbol_hit_timer
var lives = 2
var max_lives = 5
var archer_2_instance
var bonus_pop

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	global = get_tree().root.get_child(0)
	screen_size = get_viewport_rect().size
	global.screen_size = screen_size
	global.score = 0
	$bird.position = Vector2(60, 60)
	$archer.connect("shot_fired" , self, "_shot_fired")
	$archer.connect("game_over" , self, "_on_game_over")
	$archer2.get_node("Sprite").set_flip_h(true)
	$archer2.connect("shot_fired", self, "_shot_fired")
	get_signal_list()
	# set archer positions
	$archer.position = Vector2(50, $menu.position.y)
	$archer2.position = Vector2(screen_size.x - 110, $menu.position.y)
	archer_2_instance = $archer2
	remove_child($archer2)
	#set_archer_properties($archer, 3)
	$PopTimer.connect("timeout", self, "on_PopTimer_cooldown")


func add_archer():
	archer_2_instance.name = "archer2"
	add_child(archer_2_instance)
	
func remove_archer():
	for i in self.get_children():
		if "archer2" in i.name:
			remove_child(i)

func _shot_fired(node):
	var pos = node.position
	pos.y -= 30
	var shot = arrow.instance()
	shot.position = pos
	shot.dir = node.dir
	shot.x_speed = node.archer_speed / 2
	add_child(shot)
	
func check_game_over():
	if lives <= 0:	
		$CanvasLayer.get_node("game_over").update_score_labels()
		$CanvasLayer.get_node("game_over").res_button.grab_focus()
		$CanvasLayer.get_node("game_over").visible = not $CanvasLayer.get_node("game_over").visible 
		get_tree().paused = not get_tree().paused
	else: lives -= 1

func _process(delta):
	boost_display($bird.remaining_boosts)
	lives_display(lives)
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


func _on_MobileControls_left_swipe(start_postion):
	$bird.left_move()
	
func _on_MobileControls_right_swipe(start_position):
	$bird.right_move()

func _on_MobileControls_jump(start_position):
	print("in loop")
	$bird.jump()

# function to control boost display symbols
func boost_display(n):
	for count in $boosts.get_children():
		if int(count.name) > n:
			count.visible = false
		if int(count.name) <= n:
			count.visible = true
			
func lives_display(n):
	for count in $lives.get_children():
		if int(count.name) > n:
			count.visible = false
		if int(count.name) <= n:
			count.visible = true

# function to control sprite glow color
func sprite_color(sprite, color):
	if color == "red":
		sprite.modulate = Color(1, 0, 0)
	if color == "green":
		sprite.modulate = Color(0, 1, 0)
	if color == "yellow":
		sprite.modulate = Color(1, 1, 0)

func set_active_bar():
	if $bird.last_collided_bar == "left_bar":
		$"right_bar/bar_glow".visible = true
		$"left_bar/bar_glow".visible = false
		#for child in $left_glowers.get_children():
			
	if $bird.last_collided_bar == "right_bar":
		$"left_bar/bar_glow".visible = true
		$"right_bar/bar_glow".visible = false
	
func set_archer_properties(archer, shoot_interval = 2):
	archer.shoot_interval = shoot_interval

func score_pop(pos, value=1, bonus=false):
	var pop = ScorePop.instance()
	pop.position = pos
	pop.get_node("Label").text = "+" + str(value)
	if bonus == true:
		bonus_pop = pop
		$PopTimer.start()
	else: add_child(pop)

func on_PopTimer_cooldown():
	add_child(bonus_pop)
