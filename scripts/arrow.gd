extends Area2D


var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	#self.position.x = screen_size.x/2
	#self.position.y = screen_size.y
	$AnimateSprite.animation = "move"
	$AnimateSprite.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position.y -= 4


func _on_arrow_body_entered(body):
	get_tree().change_scene("game over.tscn")
