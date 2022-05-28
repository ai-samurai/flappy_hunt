extends Area2D

var type = "normal"
var status = "sleep"
var area_collision
var glow_timer
var danger_glower_time = 5
var power_glower_time = 3
var main
var archer_timer
var status_array = []

func _ready():
	status_array = ["bonus", "bonus", "life", "life", "danger", "boost", "multi", "multi"]
	main = get_parent().get_parent()
	glow_timer = add_timer("glow_timer", power_glower_time, "on_glow_timer_cooldown")
	archer_timer = add_timer("archer_timer", 5, "on_archer_timer_cooldown")
	
	
func add_timer(timer_name, time, function, one_shot = true):
	var timer = Timer.new()
	timer.name = timer_name
	timer.set_wait_time(time)
	timer.set_one_shot(one_shot)
	add_child(timer)
	timer.connect("timeout", self, function)
	return timer

func change_status(change):
	status = change
	if status == "danger":
		glow_timer.set_wait_time(danger_glower_time)
		glow_timer.start()
	else: 
		glow_timer.set_wait_time(power_glower_time)
		glow_timer.start()
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
	if status == "multi":
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
	if status == "multi":		
		status = "normal"
		$Sprite.modulate = Color(1, 1, 1)
		body.change_mode("hard")
	elif status == "danger":
		if main.get_node("archer2"):
			pass
		else: 
			body.change_mode("hard")
			main.add_archer()
			archer_timer.start()
		#self.get_parent().get_parent().check_game_over()
		
func on_glow_timer_cooldown():
	if status != "normal":
		status = "normal"
		$Sprite.modulate = Color(1, 1, 1)

func on_archer_timer_cooldown():
	main.remove_archer()
	main.get_node("bird").mode = "normal"


