extends Node
# Detects swipe gestures and generates InputEventSwipe events
# that are fed back into the engine.


signal swipe_canceled(start_position)
signal left_swipe(start_postion)
signal right_swipe(start_position)
signal jump(start_position)

export(float, 1.0, 1.5) var max_diagonal_slope: = 1.2

onready var timer = $Timer
var swipe_start_position: = Vector2()


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventScreenTouch:
		return
	if event.pressed:
		_start_detection(event.position)
	elif not timer.is_stopped():
		_end_detection(event.position)


func _start_detection(position: Vector2) -> void:
	swipe_start_position = position
	timer.start()


func _end_detection(position: Vector2) -> void:
	timer.stop()
	#$Label.text = str((position - swipe_start_position).normalized())
	var direction: Vector2 = (position - swipe_start_position).normalized()
	# Swipe angle is too steep
	
	if direction.y < -0.5:
		emit_signal("jump", swipe_start_position)
		return
	emit_swipe_signal(direction)

# determine swipe is left or right and emit signal
func emit_swipe_signal(direction):
	if direction.x < 0:
		emit_signal("left_swipe", swipe_start_position)
	elif direction.x > 0:
		emit_signal("right_swipe", swipe_start_position)
	else: pass	
	

func _on_Timer_timeout() -> void:
	emit_signal('swipe_canceled', swipe_start_position)
