extends Node2D

var obstacle = preload("res://falling_object.tscn")
var spawn_time_min = 1
var spawn_time_max = 3
var announcement_delay_time = 6

var score = 0
var lives = 3
var current_stage = 0
var target_shape = 0 # 0: Triangle, 1: Rectangle, 2: Square
var stage_duration = 60 # 60 seconds (1 minute) per stage
var stage_time_remaining = 0

# Stages configuration [shape_type, duration_in_seconds]
var stages = [
	[0, stage_duration], # Stage 1: Collect Triangles for 60 seconds
	[1, stage_duration], # Stage 2: Collect Rectangles for 60 seconds
	[2, stage_duration]  # Stage 3: Collect Squares for 60 seconds
]

func _ready() -> void:
	# Start the timer with random time
	randomize() # Initialize random number generator
	reset_timer()
	
	# Connect the player's shape_collected signal
	$Player.connect("shape_collected", _on_shape_collected)
	
	# Start the first stage
	start_stage(current_stage)

func _process(delta: float) -> void:
	# Update stage timer
	if stage_time_remaining > 0:
		stage_time_remaining -= delta
		update_timer_display()
		
		# Check if stage is complete
		if stage_time_remaining <= 0:
			advance_to_next_stage()

func reset_timer() -> void:
	# Set a random time for the next spawn
	var t = randf_range(spawn_time_min, spawn_time_max)
	$SpawnTimer.start(t)

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
	if shape_type == target_shape:
		score = score + 1
		# Update score label
		update_score_display()
	else:
		# Wrong shape collected
		lose_life()

func lose_life():
	lives -= 1
	update_lives_display()
	
	if lives <= 0:
		game_over()
	else:
		$WrongShapeSound.play() # Play a sound effect
		$Player.flash_damage() # Flash the player red

func game_over():
	# Stop all timers
	$SpawnTimer.stop()
	
	# Show game over screen
	$GameOverPanel.visible = true
	$GameOverPanel/FinalScoreLabel.text = "Final Score: " + str(score)

func start_stage(stage_index):
	if stage_index < stages.size():
		# Set target shape and duration for this stage
		target_shape = stages[stage_index][0]
		stage_time_remaining = stages[stage_index][1]
		
		# Update UI
		update_stage_display()
		update_timer_display()
		
		$SpawnTimer.stop()
		
		# Announce new stage (optional)
		show_stage_announcement()
		# Create and start a timer for 6 seconds
		var announcement_delay = Timer.new()
		announcement_delay.one_shot = true
		announcement_delay.wait_time = announcement_delay_time
		add_child(announcement_delay)
		announcement_delay.start()
		# Wait until the timer finishes
		await announcement_delay.timeout
		# Remove the timer
		announcement_delay.queue_free()
		# Hide the announcement panel
		$StageAnnouncementPanel.visible = false
		# Now actually start the stage (restart the spawn timer)
		reset_timer()
		
		
	else:
		# Game completed - all stages finished
		$GameCompletedPanel.visible = true
		$GameCompletedPanel/FinalScoreLabel.text = "Final Score: " + str(score)
		$SpawnTimer.stop()

func advance_to_next_stage():
	current_stage += 1
	
	if current_stage < stages.size():
		start_stage(current_stage)
	else:
		# All stages completed, show victory screen
		$GameCompletedPanel.visible = true
		$GameCompletedPanel/FinalScoreLabel.text = "Final Score: " + str(score)
		$SpawnTimer.stop()

func update_score_display():
	$ScoreLabel.text = "ניקוד: " + str(score)

func update_lives_display():
	$LivesLabel.text = "חיים: " + str(lives)

func update_stage_display():
	var shape_name = ""
	match target_shape:
		0: shape_name = "משולשים"  # Triangles
		1: shape_name = "מלבנים"   # Rectangles
		2: shape_name = "ריבועים"  # Squares
	
	$StageLabel.text = "שלב " + str(current_stage + 1) + ": אסוף " + shape_name

func update_timer_display():
	var minutes = int(stage_time_remaining / 60)
	var seconds = int(stage_time_remaining) % 60
	$TimerLabel.text = "%02d:%02d" % [minutes, seconds]

func show_stage_announcement():
	var shape_name = ""
	match target_shape:
		0: shape_name = "משולשים"  # Triangles
		1: shape_name = "מלבנים"   # Rectangles
		2: shape_name = "ריבועים"  # Squares
	
	$StageAnnouncementPanel.visible = true
	$StageAnnouncementPanel/AnnouncementLabel.text = "שלב " + str(current_stage + 1) + "\nאסוף " + shape_name + " בלבד!"
	
func _on_stage_announcement_timer_timeout():
	$StageAnnouncementPanel.visible = false

func _on_restart_button_pressed():
	# Reset game and start over
	score = 0
	lives = 3
	current_stage = 0
	
	# Hide panels
	$GameOverPanel.visible = false
	$GameCompletedPanel.visible = false
	
	# Update UI
	update_score_display()
	update_lives_display()
	
	# Start first stage
	start_stage(current_stage)
	
	# Restart spawn timer
	reset_timer()
