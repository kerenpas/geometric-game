extends Node2D

var obstacle = preload("res://falling_object.tscn")
var t = randf_range(0.3,1)

func _ready() -> void:
	$Timer.start(t)
	

func _on_timer_timeout() -> void:
	var screen = get_viewport_rect().size
	var position = Vector2(randf_range(0,screen.x),-600)
	
	var obstacle = load("res://falling_object.tscn")
	obstacle = obstacle.instantiate()
	
	obstacle.position = position
	add_child(obstacle)
	
