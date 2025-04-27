extends Area2D

@export var speed: int = 200

var velocity = Vector2()
var screen_size
var score = 0

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
	# Check if the colliding area is a falling object
	if area.has_method("setup_shape"):
		# Get the shape type of the collected object
		var shape_type = area.shape_type
		
		# Update the score based on shape type
		match shape_type:
			0: # Triangle
				score += 3
			1: # Rectangle
				score += 2
			2: # Square
				score += 1
				
		# Emit signal with the shape type
		emit_signal("shape_collected", shape_type)
		
		# Output score to console (you can update a UI label instead)
		print("Score: ", score)
