extends AnimatedSprite2D


@onready var sfx = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("kaboom babey")
	sfx.pitch_scale = randf_range(0.8, 1.2)
	sfx.play()
	animation_finished.connect(die)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func die():
	queue_free()
	pass
