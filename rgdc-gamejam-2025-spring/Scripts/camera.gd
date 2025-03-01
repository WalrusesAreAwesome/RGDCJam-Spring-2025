extends Camera2D

var viewport
var zoomFactor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	viewport = get_viewport().size
	zoomFactor = min( viewport.x/12.0, viewport.y / 7.5  ) / 30
	set_zoom( Vector2(zoomFactor, zoomFactor) )
	pass
