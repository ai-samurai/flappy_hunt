extends KinematicBody2D


var speed
export var default_speed = 4
var max_speed
export var boost_multiplier = 3.0
var jump = false
var screen_size
var velocity = Vector2()
var dir = 1
var jump_cooldown
var bounce_cooldown
var hit_cooldown
var allow_jump = true
export var gravity = 0.2
#var default_gravity = 0.2
var global
var selected = false
var remaining_boosts = 2
var main
var last_collided_bar = "left_bar"
var active_bar
var rng

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_tree().root.get_child(0)
	main = get_parent()
	screen_size = get_viewport_rect().size
	#$AnimatedSprite.play()
	max_speed = default_speed * boost_multiplier
	speed = default_speed
	jump_cooldown = add_timer("jump_cooldown", 0.2, "on_jump_cooldown_complete")
	bounce_cooldown = add_timer("bounce_cooldown", 0.1, "on_bounce_cooldown_complete")
	hit_cooldown = add_timer("hit_cooldown", 0.6, "on_hit_cooldown_complete")
	rng = RandomNumberGenerator.new()
	rng.randomize()

# add a timer to the main_scene
func add_timer(timer_name, time, timer_function, one_shot=true):
	var timer = Timer.new()
	timer.set_one_shot(one_shot)
	timer.set_wait_time(time)
	add_child(timer)
	timer.name = timer_name
	timer.connect("timeout", self, timer_function)
	return timer

func on_jump_cooldown_complete():
	allow_jump = true
	
func on_bounce_cooldown_complete():
	main.get_node("border/collider").disabled = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	if self.position.x > screen_size.x: 
#		dir = -1
#		remaining_boosts = 1
#	elif self.position.x < 0: 
#		dir = 1
#		remaining_boosts = 1
#	else: pass

	if Input.is_action_just_pressed("ui_select"):
		jump()
	if Input.is_action_just_pressed("ui_left"):
		left_move()
	if Input.is_action_just_pressed("ui_right"):
		right_move()

func _physics_process(delta):
	if speed > max_speed:
		speed = max_speed
	if speed > default_speed:
		if speed < default_speed * 1.8:
			speed = default_speed
		else: speed -= 0.15
	else: 
		velocity.y += gravity
	if jump == true:
		jump = false
		velocity.y = -7 
		speed = default_speed
	velocity.x = dir * speed
	var collision = move_and_collide(velocity)
	if collision:
		var groups = collision.collider.get_groups()
		if not "bars" in groups and not "border" in groups: #if not "bar" in collision.collider.name and not "border" in collision.collider.name: 
			hit()
			main.check_game_over()
		if "bars" in groups:
			if last_collided_bar:
				if last_collided_bar != collision.collider.name:
					last_collided_bar = collision.collider.name
					increase_score()
					activate_glower()
					if remaining_boosts < 5: # maximum boosts allowed
						remaining_boosts += 1
			main.set_active_bar()
			dir = -1 * dir
		if "border" in groups:
			main.get_node("border/collider").disabled = true
			velocity.y = -0.7 * (velocity.y)
			bounce_cooldown.start()
	if selected and not collision:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)

func _on_bird_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click") and main.test == true:
		selected = true

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			selected = false

func left_move():
	if dir == -1 and remaining_boosts > 0:
		boost()
	dir = -1

func right_move():
	if dir == 1 and remaining_boosts > 0:
		boost()
	dir = 1

func jump():
	if allow_jump == true:
		allow_jump = false
		jump = true
		jump_cooldown.start()

func increase_score(x = 1):
	global.score += x

# change speed to max speed and reduce boosts
func boost():
	remaining_boosts -= 1
	speed = max_speed
	velocity.y = 0
	
# function runs when player hits a body except bar and borders
# 1 - temporarily disable the player's collision mask and layer that interact
#	with the arrows and archers, to stop multiple collisions in a short period
# 	of time (usually a single collision visually)
# 2 - change color of player sprite when collision with enemy objects
func hit():
	set_collision_mask_bit(1, false) 
	set_collision_layer_bit(1, false)
	#$Sprite2.modulate = Color(1, 0, 0, 0.5) # change color to red
	hit_cooldown.start()
	on_take_damage()

func on_hit_cooldown_complete():
	set_collision_mask_bit(1, true)
	set_collision_layer_bit(1, true)
	$Sprite2.modulate = Color(1, 1, 1, 0.5)
	
func on_take_damage():
	$HitEffect.play("Hit")
#	# Flicker 2 times
#	for i in 2:
#		self.modulate.a = 0
#		yield(get_tree(), "idle_frame") # yield calls to make flicker slower
#		yield(get_tree(), "idle_frame")
#		self.modulate.a = 1.0
#		yield(get_tree(), "idle_frame")
#		yield(get_tree(), "idle_frame")

func glower_collision(glower):
	if glower.type == "normal":
		pass

func activate_glower():
	var num = rng.randi_range(1, 7)
	var statnum = rng.randi_range(0,2)
	var status = ["bonus", "life", "danger"][statnum]
	
		
	if "left_bar" in last_collided_bar:
		if status == "danger":
			change_all_glowers("right_glowers")
		else: main.get_node("right_glowers/" + str(num)).change_status(status)
	if "right_bar" in last_collided_bar:
		if status == "danger":
			change_all_glowers("left_glowers")
		main.get_node("left_glowers/" + str(num)).change_status(status)

func change_all_glowers(glowers):
	for i in main.get_node(glowers).get_children():
		i.change_status("danger") 
