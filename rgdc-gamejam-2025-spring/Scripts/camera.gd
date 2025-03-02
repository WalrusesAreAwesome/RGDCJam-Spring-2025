extends Camera2D

var viewport
var zoomFactor
@export var shakeFactor = 3
var shakeTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	offset = Vector2.ZERO
	shakeTimer = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	viewport = get_viewport().size
	zoomFactor = min( viewport.x/12.0, viewport.y / 7.5  ) / 30
	set_zoom( Vector2(zoomFactor, zoomFactor) )
	if (shakeTimer > 0):
		do_screen_shake(delta)
	pass


func do_screen_shake(delta):
	offset = Vector2(
		randf_range(-shakeFactor, shakeFactor), 
		randf_range(-shakeFactor, shakeFactor))
	shakeTimer -= delta


func set_screen_shake(time: float, intensity: float):
	shakeTimer = time
	shakeFactor = intensity
