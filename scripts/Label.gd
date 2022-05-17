extends Label

var global
var main
var y = 0
var max_y = 0


## Called when the node enters the scene tree for the first time.
func _ready():
	global = get_tree().root.get_child(0)
	main = get_parent()
#
#
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta):
#	#self.text = "Score: " + str(global.score)
#	y = main.get_node("bird").velocity.y * delta
#	if y > max_y:
#		max_y = y
#	self.text = "FPS: " + str(Engine.get_frames_per_second())
