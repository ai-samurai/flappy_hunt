extends Sprite

var timer
var dir = 1

func _ready():
	timer = Timer.new()
	timer.set_wait_time(1)
	add_child(timer)
	timer.connect("timeout", self, "on_timer_cooldown")
	timer.start()
	
func on_timer_cooldown():
	queue_free()
	
func _physics_process(delta):
	position.y -= 2
	#position.x += dir * 0.3
