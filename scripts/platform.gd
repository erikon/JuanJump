extends RigidBody2D

var locked_x_position: int

func _ready() -> void:
	locked_x_position = position.x

func _physics_process(_delta) -> void:
	position.x = locked_x_position

# Remove platforms when outside screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
