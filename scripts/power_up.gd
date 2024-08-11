extends Node2D

# Signals
signal grant_double_jump
signal grant_meteor

# Node references
@onready var sprite = $Sprite2D
@onready var power_up = $"."

# All available power ups
enum type_options {DOUBLE_JUMP = 0, METEOR = 1}

# Current power up type
var current_type_index: int;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_type_index = randf() * type_options.size()
	sprite.region_rect = Rect2(0, 16 * current_type_index, 16, 16)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	power_up.move_local_y(0.5)

# Send signal to enable power up
func _on_body_entered(body) -> void:
	if (body.name == 'Player'):
		if (current_type_index == type_options.DOUBLE_JUMP):
			grant_double_jump.emit()
		elif (current_type_index == type_options.METEOR):
			grant_meteor.emit()
		queue_free()
		
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
