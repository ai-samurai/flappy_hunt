extends KinematicBody2D


export var speed = 3
var default_speed = 3
var jump = false
var screen_size
var velocity = Vector2()
var dir = 1
var jump_cooldown
var bounce_cooldown
var allow_jump = true
var gravity = 0.1
var default_gravity = 0.1
var global
var selected = false
var remaining_boosts = 2
var main
var last_collided_bar = "left_bar"

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_tree().root.get_child(0)
	main = get_parent()
	screen_size = get_viewport_rect().size
	$AnimatedSprite.play()
	jump_cooldown = add_timer("jump_cooldown", 0.2, "on_jump_cooldown_complete")
	bounce_cooldown = add_timer("bounce_cooldown", 0.1, "on_bounce_cooldown_complete")


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
#func _process(delta):
##	if self.position.x > screen_size.x: 
##		dir = -1
##		remaining_boosts = 1
##	elif self.position.x < 0: 
##		dir = 1
##		remaining_boosts = 1
##	else: pass
#
#	if dir == 1: $AnimatedSprite.animation = "fly_right"
#	else: $AnimatedSprite.animation = "fly_left"
#	if Input.is_action_pressed("ui_select"):
#		pass
#	if Input.is_action_just_pressed("ui_left"):
#		pass
#	if Input.is_action_just_pressed("ui_right"):
#		pass

func _physics_process(delta):
	if speed > default_speed:
		speed -= 0.15
	else: 
		velocity.y += gravity
	if jump == true:
		jump = false
		velocity.y = -5
		speed = default_speed
	
	velocity.x = dir * speed
	
	var collision = move_and_collide(velocity)
	if collision:
		if not "bar" in collision.collider.name and not "border" in collision.collider.name: 
		#dir = -1 * dir
			main._game_over()
		if "bar" in collision.collider.name:
			if last_collided_bar:
				if last_collided_bar != collision.collider.name:
					last_collided_bar = collision.collider.name
					increase_score()
					if remaining_boosts < 4:
						remaining_boosts += 1
			dir = -1 * dir
		if "border" in collision.collider.name:
			main.get_node("border/collider").disabled = true
			velocity.y = -0.7 * velocity.y
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

func boost():
	remaining_boosts -= 1
	speed = default_speed * 3
	velocity.y = 0
