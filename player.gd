extends Area2D

@export var speed: int = 200



var velocity = Vector2()
var screen_size

func _ready() -> void:
	screen_size = get_viewport_rect().size
	
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if velocity.length()>0:
		velocity = velocity * speed	
		
	position +=velocity*delta
	position.x = clamp(position.x, 0, screen_size.x)
	
		
