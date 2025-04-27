extends Area2D

enum ShapeType {TRIANGLE, RECTANGLE, SQUARE}

@export var shape_type: ShapeType = ShapeType.SQUARE
@export var fall_speed_min: float = 5.0
@export var fall_speed_max: float = 10.0

var fall_speed: float

func _ready() -> void:
	# Set a random fall speed within the range
	fall_speed = randf_range(fall_speed_min, fall_speed_max)
	
	# Setup the shape based on the type
	setup_shape()

func setup_shape() -> void:
	# Get references to our nodes
	var sprite = $Sprite2D
	var collision = $CollisionShape2D
	
	# Setup shape based on type
	match shape_type:
		ShapeType.TRIANGLE:
		# Set triangle polygon sprite
			var polygon = Polygon2D.new()
			polygon.polygon = PackedVector2Array([
			Vector2(-50, 50),
			Vector2(50, 50),
			Vector2(0, -50)
		])
			polygon.color = Color(1, 0, 0) # Red triangle
		
		# Remove the default sprite and add our polygon
			sprite.queue_free()
			add_child(polygon)
		
			# Set triangle collision shape
			var shape = CollisionPolygon2D.new()
			shape.polygon = polygon.polygon
			collision.queue_free()
			add_child(shape)
			
		ShapeType.RECTANGLE:
		# Create a rectangle with Polygon2D
			var polygon = Polygon2D.new()
			polygon.polygon = PackedVector2Array([
				Vector2(-60, -30),  # Top-left
				Vector2(60, -30),   # Top-right
				Vector2(60, 30),    # Bottom-right
				Vector2(-60, 30)    # Bottom-left
			])
			polygon.color = Color(0, 1, 0) # Green rectangle
			
			# Remove the default sprite and add our polygon
			sprite.queue_free()
			add_child(polygon)
			
			# Set rectangle collision shape
			var shape = CollisionPolygon2D.new()
			shape.polygon = polygon.polygon
			collision.queue_free()
			add_child(shape)
			
		ShapeType.SQUARE:
		# Create a square with Polygon2D
			var polygon = Polygon2D.new()
			polygon.polygon = PackedVector2Array([
				Vector2(-50, -50),  # Top-left
				Vector2(50, -50),   # Top-right
				Vector2(50, 50),    # Bottom-right
				Vector2(-50, 50)    # Bottom-left
			])
			polygon.color = Color(0, 0, 1) # Blue square
			
			# Remove the default sprite and add our polygon
			sprite.queue_free()
			add_child(polygon)
			
			# Set square collision shape
			var shape = CollisionPolygon2D.new()
			shape.polygon = polygon.polygon
			collision.queue_free()
			add_child(shape)

func _process(delta: float) -> void:
	position.y += fall_speed * delta * 60 # Make speed frame rate independent
	# Check if object is below the screen
	var screen_size = get_viewport_rect().size
	if position.y > screen_size.y + 100:  # Add some buffer
		queue_free()  # Remove the object if it's below the screen

func _on_area_entered(area: Area2D) -> void:
	# Remove the falling object when it collides with another area
	queue_free()
