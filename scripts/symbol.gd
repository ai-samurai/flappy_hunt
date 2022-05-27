extends Area2D

var type = "normal"
var status = "sleep"
var area_collision
var timer
var danger_glower_time = 5
var power_glower_time = 3

func _ready():
	timer = Timer.new()
	timer.set_wait_time(3)
	timer.set_one_shot(true)
	add_child(timer)
	timer.connect("timeout", self, "on_timer_cooldown")
		
func change_status(change):
	status = change
	if status == "danger":
		timer.set_wait_time(danger_glower_time)
		timer.start()
	else: 
		timer.set_wait_time(power_glower_time)
		timer.start()
	if status == "normal":
		$Sprite.modulate = Color(1, 1, 1)
	if status == "life":
		$Sprite.modulate = Color(0, 1, 0) # green
	if status == "danger":
		$Sprite.modulate = Color(1, 0, 0) # red
	if status == "bonus":
		$Sprite.modulate = Color(1, 1, 0) # yellow
	if status == "boost":
		$Sprite.modulate = Color(0, 1, 1) # blue
	

func _on_1_body_entered(body):
	body.glower_collision(self)
	if status == "life":
		status = "sleep"
		$Sprite.modulate = Color(1, 1, 1)
		if self.get_parent().get_parent().lives < 4:
			self.get_parent().get_parent().lives += 1	
		pass
	if status == "bonus":
		status = "sleep"
		$Sprite.modulate = Color(1, 1, 1)
		body.increase_score(10) 
	if status == "boost":
		status = "sleep"
		$Sprite.modulate = Color(1, 1, 1)
		body.increase_boosts(body.max_boosts)
	elif status == "danger":
		self.get_parent().get_parent().check_game_over()
		
func on_timer_cooldown():
	if status != "normal":
		status = "normal"
		$Sprite.modulate = Color(1, 1, 1)



