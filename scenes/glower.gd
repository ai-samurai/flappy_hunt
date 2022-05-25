extends StaticBody2D

var type = "normal"
var status = "sleep"

func _on_1_body_entered(body):
	if status == "bonus":
		status = "normal"
		if self.get_parent().get_parent().lives < 4:
			self.get_parent().get_parent().lives += 1	
		pass
	if status == "caution":
		$Sprite.modulate = Color(1, 0, 0) # red
		status = "danger"
	elif status == "danger":
		self.get_parent().get_parent().check_game_over()
		status == "normal"
		
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
