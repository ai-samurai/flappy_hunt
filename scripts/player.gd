extends KinematicBody2D


export var speed = 200
var default_speed = 200
var screen_size
var velocity = Vector2()
var dir = 1
var jump_cooldown
var allow_jump = true
var gravity = 10
var global
var selected = false
var remaining_boosts = 3
var main
var last_collided_bar = "left_bar"

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_tree().root.get_child(0)
	main = get_parent()
	screen_size = get_viewport_rect().size
	$AnimatedSprite.play()
	jump_cooldown = add_timer("jump_cooldown", 0.2, "on_jump_cooldown_complete")


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
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.position.x > screen_size.x: 
		dir = -1
		remaining_boosts = 1
	elif self.position.x < 0: 
		dir = 1
		remaining_boosts = 1
	else: pass
	
	if dir == 1: $AnimatedSprite.animation = "fly_right"
	else: $AnimatedSprite.animation = "fly_left"
	if Input.is_action_pressed("ui_select"):
		if allow_jump == true:
			allow_jump = false
			jump_cooldown.start()
			velocity.y = -500
	if Input.is_action_just_pressed("ui_left"):
		if dir == -1 and remaining_boosts > 0:
			remaining_boosts -= 1
			speed = default_speed*3
		dir = -1
	if Input.is_action_just_pressed("ui_right"):
		if dir == 1 and remaining_boosts > 0:
			remaining_boosts -= 1
			speed = default_speed*3
		dir = 1

func _physics_process(delta):
	if speed > default_speed:
		speed -= 10
		velocity.y = 0
	else: velocity.y += gravity
	velocity.x = dir * speed
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		if not "bar" in collision.collider.name: 
		#dir = -1 * dir
			main._game_over()
		if "bar" in collision.collider.name:
			if last_collided_bar:
				if last_collided_bar != collision.collider.name:
					last_collided_bar = collision.collider.name
					increase_score()
					remaining_boosts = 1
			dir = -1 * dir
	if selected and not collision:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)


func _on_bird_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		selected = true

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			selected = false


func increase_score(x = 1):
	global.score += x
