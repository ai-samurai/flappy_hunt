extends Area2D

var archer_speed
var dir = 1 # direction of archer movement, 1: right, -1: left
var screen_size
var shoot_animation_cooldown # amount of time for ending shooting animation
var shoot_interval = 1 # time interval between successive shots
var shoot_interval_cooldown # timer for shoot interval 
var archer_size
var rng
var global

signal shot_fired


func _ready():
	"""
	Called when the node enters the scene tree for the first time.
	input: None
	returns: None
	"""
	global = get_node("/root/Global")
	rng = RandomNumberGenerator.new()
	rng.randomize()
	screen_size = get_viewport_rect().size
	archer_size = $CollisionShape2D.shape.extents
	self.position = Vector2(50, screen_size.y-(2 * archer_size.y * self.scale.y))
	archer_speed = 2
	$AnimatedSprite.animation = "walk"
	$AnimatedSprite.play()
	shoot_animation_cooldown = add_timer("shoot_cooldown", 0.45, "on_shoot_animation_cooldown")
	shoot_interval_cooldown = add_timer("shoot_interval", shoot_interval, "on_shoot_interval", false)
	shoot_interval_cooldown.start()
	


func add_timer(timer_name, time, timer_function, one_shot=true):
	"""
	function to add timer to the scene
	input: timer_name (name that will given to the timer)
			time (the wait time of the timer)
			timer_function (the function that will be called when timer ends)
			one_shot (default: true, used to determine if timer is one-time or
			if it will be repeated, =false for repeating timer)
	returns: None
	"""
	var timer = Timer.new()
	timer.set_one_shot(one_shot)
	timer.set_wait_time(time)
	add_child(timer)
	timer.name = timer_name
	timer.connect("timeout", self, timer_function)
	return timer
	
func on_shoot_interval():
	"""
	Called when the shoot interval timer is completed. shoot interval timer is 
		used to control how frequently the archer will shoot arrows. This 
		function starts the animation and then starts the animation timer.
	input: None
	returns: None
	"""
	$AnimatedSprite.animation = "shoot"
	shoot_animation_cooldown.start()

func on_shoot_animation_cooldown():
	"""
	Called when the shoot animation is completed. Currently shoot animation is
		synced with shoot animation timer manually (0.45 seconds), when timer
		ends this function is called. 
	input: None
	returns: None
	"""
	# emitted to signal that arrow has been fired
	emit_signal("shot_fired", self)
	# change the shoot_interval timer to random value between min and max. This
	# ensured that arrows are fired at random intervals
	shoot_interval_cooldown.wait_time = rng.randf_range(1, 2)
	# change animation to "walk" after arrow has been fired
	$AnimatedSprite.animation = "walk"

func _process(delta):
	"""
	Called every frame
	input: 'delta' (elapsed time since the previous frame)
	returns: None
	"""
	self.position.x += archer_speed * dir
	if self.position.x > screen_size.x - 50:	
		dir = -1
		self.scale.x = -3
	elif self.position.x < 50: 
		dir = 1
		self.scale.x = 3

func _on_archer_body_entered(body):
	"""
	Called when body enters the collision shape of self (archer in this case)
	input: body (the node that entered the collision shape)
	returns: None
	"""
	global._game_over()
