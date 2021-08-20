extends KinematicBody2D


export var speed = 150
var screen_size
var velocity = Vector2()
var dir = 1
var jump_cooldown
var allow_jump = true
var gravity = 10

# Called when the node enters the scene tree for the first time.
func _ready():
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
	if self.position.x > screen_size.x: dir = -1
	elif self.position.x < 0: dir = 1
	else: pass
	velocity.x = dir * speed
	velocity.y += gravity
	move_and_slide(velocity)
	if dir == 1: $AnimatedSprite.animation = "fly_right"
	else: $AnimatedSprite.animation = "fly_left"
	if Input.is_action_pressed("ui_select"):
		if allow_jump == true:
			allow_jump = false
			jump_cooldown.start()
			velocity.y = -400
