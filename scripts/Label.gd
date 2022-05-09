extends Label

var global


## Called when the node enters the scene tree for the first time.
func _ready():
	global = get_tree().root.get_child(0)
#
#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.text = "Score: " + str(global.score)
