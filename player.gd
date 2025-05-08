extends Area2D

@export var speed: int = 200

var velocity = Vector2()
var screen_size
var can_collect = true  # Flag to prevent multiple collections at once

signal shape_collected(shape_type)

func _ready() -> void:
	screen_size = get_viewport_rect().size
	# Connect signal for collision with falling objects
	connect("area_entered", _on_area_entered)
	
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if velocity.length() > 0:
		velocity = velocity * speed	
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)

func _on_area_entered(area: Area2D) -> void:
	# Check if the colliding area is a falling object and player can collect
	if area.has_method("setup_shape") and can_collect:
		# Get the shape type of the collected object
		var shape_type = area.shape_type
		# Emit signal with the shape type
		emit_signal("shape_collected", shape_type)

# Function to flash the player red when they lose a life
func flash_damage():
	can_collect = false  # Disable collection during animation
	
	# Store original color
	var original_color = $Sprite2D.modulate
	
	# Flash red
	$Sprite2D.modulate = Color(1, 0, 0)  # Red
	
	# Create a timer for the flash duration
	var flash_timer = Timer.new()
	flash_timer.wait_time = 0.2
	flash_timer.one_shot = true
	add_child(flash_timer)
	flash_timer.start()
	
	# Wait until timer finishes
	await flash_timer.timeout
	
	# Return to original color
	$Sprite2D.modulate = original_color
	flash_timer.queue_free()
	
	can_collect = true  # Re-enable collection
