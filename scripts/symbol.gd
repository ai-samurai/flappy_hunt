extends Area2D

var type = "normal"
var status = "sleep"
var area_collision
var timer
var danger_glower_time = 5
var power_glower_time = 3
var main

func _ready():
	main = get_parent().get_parent()
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
	if status == "save":
		$Sprite.modulate = Color(1, 0, 1)
	

func _on_1_body_entered(body):
	body.glower_collision(self)
	if status == "life":
		status = "normal"
		$Sprite.modulate = Color(1, 1, 1)
		if main.lives < main.max_lives:
			main.lives += 1	
		pass
	if status == "bonus":
		status = "normal"
		$Sprite.modulate = Color(1, 1, 1)
		body.increase_score(10) 
	if status == "boost":
		status = "normal"
		$Sprite.modulate = Color(1, 1, 1)
		body.increase_boost(body.max_boosts)
	if status == "save":		
		status = "normal"
		$Sprite.modulate = Color(1, 1, 1)
		main.remove_archer()
	elif status == "danger":
		if main.get_node("archer2"):
			pass
		else: 
			main.add_archer()
		#self.get_parent().get_parent().check_game_over()
		
func on_timer_cooldown():
	if status != "normal":
		status = "normal"
		$Sprite.modulate = Color(1, 1, 1)



