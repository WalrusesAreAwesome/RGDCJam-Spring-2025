class_name player_controller extends CharacterBody2D

var isPouncing = false
var pounceVelocity = Vector2.ZERO
@export var walkSpeed = 50


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _physics_process(delta: float) -> void:
	update_position()
	move_and_slide()


func update_position():
	if (isPouncing):
		self.position += pounceVelocity
		pass
	
	# Not pouncing
	var frameVelocity = Vector2.ZERO
	if (Input.is_action_pressed("left")):
		frameVelocity += Vector2(-1, 0)
	if (Input.is_action_pressed("right")):
		frameVelocity += Vector2(1, 0)
	if (Input.is_action_pressed("up")):
		frameVelocity += Vector2(0, -1)
	if (Input.is_action_pressed("down")):
		frameVelocity += Vector2(0, 1)
	
	velocity = frameVelocity.normalized() * walkSpeed
