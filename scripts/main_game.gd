extends Node2D

# Select the Platform Scene
@export var platform_scene: PackedScene

var platform_counter: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass

func _on_start_timer_timeout() -> void:
	# TODO: Add UI Timer Countdown for when game starts i.e. 5...4...3
	$Timers/PlatformTimer.start()
	$Timers/GroundTimer.start()

# Delete ground when out of camera view
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$Timers/GroundTimer.stop()

func _on_platform_timer_timeout() -> void:
	# Increment Platform Timer Count - to be used to increase velocity of platforms over time
	platform_counter += 1
	
	var platform = platform_scene.instantiate()

	# Choose a random location on Path2D
	var platform_spawn_location = $PlatformPath/PlatformSpawnLocation
	platform_spawn_location.progress_ratio = randf()

	# Set the platform's position to a random location
	platform.position = platform_spawn_location.position

	# Choose the velocity for the platform
	var velocity = Vector2(0.0, 100.0)
	if platform_counter > 10:
		velocity.y += 50 * (platform_counter / 10)
	platform.linear_velocity = velocity

	# Spawn the platform by adding it to the main scene
	add_child(platform)
