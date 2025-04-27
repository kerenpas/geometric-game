extends Node2D

var obstacle = preload("res://falling_object.tscn")
var spawn_time_min = 0.3
var spawn_time_max = 1.0

var score = 0

func _ready() -> void:
	# Start the timer with random time
	randomize() # Initialize random number generator
	reset_timer()
		# Connect the player's shape_collected signal
	$Player.connect("shape_collected", _on_shape_collected)

func reset_timer() -> void:
	# Set a random time for the next spawn
	var t = randf_range(spawn_time_min, spawn_time_max)
	$Timer.start(t)

func _on_timer_timeout() -> void:
	# Get screen size
	var screen = get_viewport_rect().size
	
	# Random position along the top of the screen (off-screen)
	var position = Vector2(randf_range(0, screen.x), -100)
	
	# Instantiate a new obstacle
	var new_obstacle = obstacle.instantiate()
	
	# Set a random shape type (Triangle, Rectangle, or Square)
	new_obstacle.shape_type = randi() % 3 # Randomly choose 0, 1, or 2
	
	# Set the position and add it to the scene
	new_obstacle.position = position
	add_child(new_obstacle)
	
	# Reset the timer for the next spawn
	reset_timer()
	
func _on_shape_collected(shape_type):
	# Update score based on shape type
	match shape_type:
		0: # Triangle
			score += 3
		1: # Rectangle
			score += 2
		2: # Square
			score += 1
	
	# Update score label
	$ScoreLabel.text = "ניקוד: " + str(score)
