extends RigidBody2D
signal hit

var locked_x_position: int

func _ready() -> void:
	locked_x_position = position.x
	
func _physics_process(_delta) -> void:
	position.x = locked_x_position

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_hit_box_body_entered(body):
	if (body.name == 'Player'):
		hit.emit()
