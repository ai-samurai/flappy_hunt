extends Area2D

var archer_speed
var dir = 1
var screen_size
var shoot_animation_cooldown # amount of time for ending shooting animation
var shoot_interval = 1 # time interval between successive shots
var shoot_interval_cooldown # timer for shoot interval 
var archer_size

signal shot_fired
signal game_over

# Called when the node enters the scene tree for the first time.
func _ready():
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
	var timer = Timer.new()
	timer.set_one_shot(one_shot)
	timer.set_wait_time(time)
	add_child(timer)
	timer.name = timer_name
	timer.connect("timeout", self, timer_function)
	return timer
	
func on_shoot_interval():
	$AnimatedSprite.animation = "shoot"
	shoot_animation_cooldown.start()

func on_shoot_animation_cooldown():
	emit_signal("shot_fired", self)
	shoot_interval_cooldown.wait_time = rand_range(0.5, 1.5)
	$AnimatedSprite.animation = "walk"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position.x += archer_speed * dir
	if self.position.x > screen_size.x - 50:	
		dir = -1
		self.scale.x = -3
	elif self.position.x < 50: 
		dir = 1
		self.scale.x = 3

func _on_archer_body_entered(body):
	get_tree().change_scene("game over.tscn")
