extends AnimatableBody2D

var ground_move: bool = false
@onready var ground = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:	
	if ground_move:
		ground.position.y += 1

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_ground_timer_timeout():
	print("Ground Timer Up")
	ground_move = true
