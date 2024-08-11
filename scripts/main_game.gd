extends Node2D

# Set the different platform scenes
@export var standard_platform_scene: PackedScene
@export var water_platform_scene: PackedScene
@export var ice_platform_scene: PackedScene
@export var power_up_scene: PackedScene

@onready var ground = $LevelDesignNodes/Ground
@onready var player = $Player

@onready var gameOverText = $LevelDesignNodes/GameOverText

var platform_counter: int = 0
var platform_speed: Vector2 = Vector2(0.0, 200.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass

# Start a new game
func new_game() -> void:
	# Remove all platforms from previous game
	get_tree().call_group("platforms", "queue_free")
	
	# Set start positions
	ground.start($StartPositionNodes/GroundStartPosition.position)
	player.start($StartPositionNodes/PlayerStartPosition.position)
	# Restart timers
	$Timers/StartTimer.start()
	# Set GameOver text invisible
	gameOverText.visible = false
	# Reset platform counter
	platform_counter = 0
	platform_speed = Vector2(0.0, 200.0)

func _on_start_timer_timeout() -> void:
	# TODO: Add UI Timer Countdown for when game starts i.e. 5...4...3
	$Timers/PlatformTimer.start()
	$Timers/GroundTimer.start()
	$Timers/PowerUpTimer.start()

# Delete ground when out of camera view
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$Timers/GroundTimer.stop()

func _on_power_up_timer_timeout():
	var power_up = power_up_scene.instantiate()
	var power_up_spawn_location = $PowerUpPath/PowerUpSpawnLocation
	power_up_spawn_location.progress_ratio = randf()
	power_up.position = power_up_spawn_location.position
	power_up.connect("grant_double_jump", player._on_power_up_grant_double_jump)
	power_up.connect("grant_meteor", player._on_power_up_grant_meteor)
	add_child(power_up)

func _on_platform_timer_timeout() -> void:
	var random_platforms: Array[PackedScene] = [standard_platform_scene, water_platform_scene, ice_platform_scene]
	#var random_platforms: Array[PackedScene] = [ice_platform_scene]

	# Increment Platform Timer Count - to be used to increase velocity of platforms over time
	platform_counter += 1
	
	#var platform = standard_platform_scene.instantiate()
	var platform = random_platforms.pick_random().instantiate()

	if platform.name == "WaterPlatform":
		platform.hit.connect(_game_over)
		platform.hit.connect(player._game_over)
		
	# Choose a random location on Path2D
	var platform_spawn_location = $PlatformPath/PlatformSpawnLocation
	platform_spawn_location.progress_ratio = randf()

	# Set the platform's position to a random location
	platform.position = platform_spawn_location.position

	# Choose the velocity for the platform
	
	if platform_counter > 10:
		platform_speed.y += 5 * (platform_counter / 5)
	platform.linear_velocity = platform_speed

	# Spawn the platform by adding it to the main scene
	add_child(platform)

func _game_over() -> void:
	gameOverText.visible = true
	$Timers/PlatformTimer.stop()
	$Timers/RestartTimer.start()
	
# Restart the game once RestartTimer times out
func _restart() -> void:
	$Timers/RestartTimer.stop()
	print("Restarting game")
	new_game()

