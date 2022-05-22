extends Area2D

var type = "normal"
var status = "sleep"


func _on_1_body_entered(body):
	if status == "bonus":
		#status = "sleep"
		if self.get_parent().get_parent().lives < 4:
			self.get_parent().get_parent().lives += 1	
	if status == "caution":
		$Sprite.modulate = Color(1, 0, 0) # red
		status = "danger"
	elif status == "danger":
		self.get_parent().get_parent().check_game_over()
		



