extends Area2D

var type = "normal"
var status = "sleep"
var area_collision

		
func change_status(change):
	status = change
	if status == "normal":
		$Sprite.modulate = Color(1, 1, 1)
	if status == "life":
		$Sprite.modulate = Color(0, 1, 0)
	if status == "danger":
		$Sprite.modulate = Color(1, 0, 0)
	if status == "bonus":
		print("in loop")
		$Sprite.modulate = Color(0, 1, 1)

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
		



