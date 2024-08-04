extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -800.0

var isDead = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var player = $"."

func _physics_process(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("left", "right")
	
	# Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if is_on_floor():
		animated_sprite.play("idle")
	else:
		animated_sprite.play("jump")
		
	# Apply movement to character
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Check if dead
	if isDead:
		animated_sprite.play("death")
		player.gravity = -1
		position.y -= 1
		velocity.y = -1

	move_and_slide()

func _game_over() -> void:
	isDead = true
	
func start(pos) -> void:
	position = pos
	isDead = false
	player.gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	

