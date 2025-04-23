extends Area2D


func _process(delta: float) -> void:
	position.y += randf_range(4,10)
	


func _on_area_entered(area: Area2D) -> void:
	queue_free()
