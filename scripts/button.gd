extends TouchScreenButton

var timer = Timer.new()

func _ready():
	timer.set_one_shot(true)
	timer.set_wait_time(0.1)
	timer.connect("timeout", self, "on_timeout")

func on_timeout():
	self.set_block_signals(false)
		
func _unhandled_input(event):
	if event is InputEventScreenTouch:
		self.set_block_signals(true)
		timer.start()

