extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("kaboom babey")
	animation_finished.connect(die)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func die():
	queue_free()
	pass
