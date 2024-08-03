extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_start_timer_timeout():
	# TODO: Add UI Timer Countdown for when game starts i.e. 5...4...3
	print("Timer end")
	
	# TODO:
	# 1. Spawn platforms at top of screen
	# 	- platforms automatically move downwards
	# 2. Kick off ground movement timer (after 2sec, ground moves down)
	print("kick off ground timer")
	$GroundTimer.start()

# Delete ground when out of camera view
func _on_visible_on_screen_notifier_2d_screen_exited():
	$GroundTimer.stop()
