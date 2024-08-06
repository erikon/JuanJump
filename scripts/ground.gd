extends AnimatableBody2D

var ground_move: bool = false
@onready var ground = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:	
	if ground_move:
		ground.position.y += 1

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	ground_move = false
	# queue_free() - not freeing instance for restarting game

func _on_ground_timer_timeout() -> void:
	print("Ground Timer Up")
	ground_move = true
	
func start(pos) -> void:
	position = pos
	ground_move = false
