extends Area2D

var type = "normal"
var status = "sleep"
var area_collision
var timer

func _ready():
	timer = Timer.new()
	timer.set_wait_time(3)
	timer.set_one_shot(true)
	add_child(timer)
	timer.connect("timeout", self, "on_timer_cooldown")
		
func change_status(change):
	status = change
	if status == "danger":
		timer.set_wait_time(5)
		timer.start()
	else: 
		timer.set_wait_time(3)
		timer.start()
	if status == "normal":
		$Sprite.modulate = Color(1, 1, 1)
	if status == "life":
		$Sprite.modulate = Color(0, 1, 0) # green
	if status == "danger":
		$Sprite.modulate = Color(1, 0, 0) # red
	if status == "bonus":
		$Sprite.modulate = Color(0, 1, 1) # blue
	if status == "caution":
		$Sprite.modulate = Color(1, 1, 0) # yellow
	

func _on_1_body_entered(body):
	body.glower_collision(self)
	if status == "bonus":
		status = "sleep"
		$Sprite.modulate = Color(1, 1, 1)
		if self.get_parent().get_parent().lives < 4:
			self.get_parent().get_parent().lives += 1	
		pass
	if status == "caution":
		$Sprite.modulate = Color(1, 0, 0) # red
		status = "danger"
	elif status == "danger":
		self.get_parent().get_parent().check_game_over()
		
func on_timer_cooldown():
	if status != "normal":
		status = "normal"
		$Sprite.modulate = Color(1, 1, 1)



