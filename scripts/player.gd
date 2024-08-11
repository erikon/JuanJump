extends CharacterBody2D

# CONSTANTS
const SPEED = 300.0
const JUMP_VELOCITY = -600.0
const DOWN_VELOCITY = 1000.0
const MAXIMUM_JUMP_COUNT = 2

# Flag for handling character state
var isDead = false
var jump_count = 0
var isGrantedDoubleJump = false
var isGrantedMeteor = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var player = $"."

func _physics_process(delta) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta	# Add the gravity.
	else:
		jump_count = 0	# Reset jump_count

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			animated_sprite.play("jump")
			velocity.y = JUMP_VELOCITY
			jump_count += 1
		elif isGrantedDoubleJump && jump_count < MAXIMUM_JUMP_COUNT:
			animated_sprite.play("jump")
			velocity.y = JUMP_VELOCITY
			jump_count += 1
	
	# Handle meteor (descent acceleration)
	if (isGrantedMeteor && Input.is_action_just_pressed("down")):
		velocity.y = DOWN_VELOCITY
	
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
	
func _on_power_up_grant_double_jump():
	isGrantedDoubleJump = true
	
func _on_power_up_grant_meteor():
	isGrantedMeteor = true

func _game_over() -> void:
	isDead = true
	
func start(pos) -> void:
	position = pos
	isDead = false
	isGrantedDoubleJump = false
	player.gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



