extends RigidBody2D

@onready var animation_player = $AnimationPlayer
var locked_x_position: int

func _ready() -> void:       
	locked_x_position = position.x

func _physics_process(_delta) -> void:
	position.x = locked_x_position

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_hit_box_body_entered(body):
	if (body.name == 'Player'):
		# Play disappearing animation - when finished the VisibleOnScreen signal is fired which deletes the node
		animation_player.play("platform_melt")
