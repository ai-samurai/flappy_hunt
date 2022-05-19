extends KinematicBody2D


var screen_size
var start_speed = 4 # orignal = 11
var acc = 1.25 # original = 8
var min_speed = 2
var speed
var dir = 1
var x_speed = 0

var global


func _ready():
	"""
	Called when the node enters the scene tree for the first time.
	input: None
	returns: None
	"""
	screen_size = get_viewport_rect().size
	global = get_node("/root/Global")
	$AnimateSprite.animation = "move"
	$AnimateSprite.play()
	speed = start_speed
	acc = start_speed/3.0


func _physics_process(delta):
	"""
	Called every frame. 'delta' is the elapsed time since the previous frame.
	returns: None
	"""
	x_pos(delta)
	y_pos(delta)
	rotate_arrow(dir)
	arrow_exit()

func x_pos(delta):
	"""
	function to control the x position of the arrow
	input: delta
	returns: None
	"""
	#self.position.x += x_speed * dir
	pass
	
func y_pos(delta):
	"""
	function to control the y position of the arrow
	input: delta
	returns: None
	"""
	speed -= acc * delta
	self.position.y -= speed
	

func rotate_arrow(direction):
	"""
	function to control the rotation of the arrow
	input: direction (indicates the direction of rotation, decided using
		direction of the archer's movement when arrow was fired)
	returns: None
	"""
	# to control the speed of the rotation
	var offset = 5 * direction
	# if statement to determine which direction the arrow should rotate in
	if direction > 0:
		# if statement to decide when arrow should start rotating
		if speed <= 3 and self.rotation_degrees <= 180: 
			# self.rotation_degrees + offset <= 180 check is necessary 
			# otherwise arrow will rotate past 180 in that last offset addition
			if self.rotation_degrees + offset <= 180:
				self.rotation_degrees += offset
			else: self.rotation_degrees = 180
	else: 
		# -ve 180 degrees since arrow is rotating counter-clockwise if this 
		# part is reached in the if-else construct
		if speed <= 3 and self.rotation_degrees >= -180: 
			if self.rotation_degrees + offset >= -180:
				self.rotation_degrees += offset
			else: self.rotation_degrees = -180
	
func arrow_exit():
	"""
	function to control what happens when arrow exits the scene or when height
	is negative i.e. below ground level in the scene (not -ve y value)
	input: None
	returns: None
	"""
	
	if self.position.y > screen_size.y:
		#global.score += 1  
		queue_free()

#func _on_arrow_body_entered(body):
#	"""
#	Called when body enters the collision shape of self
#	input: body (the node that entered the arrow's collision shape)
#	returns: None
#	"""
#	get_tree().paused = true
#	global._game_over()
