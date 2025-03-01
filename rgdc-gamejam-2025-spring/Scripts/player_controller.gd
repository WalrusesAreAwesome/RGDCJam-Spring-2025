class_name player_controller extends CharacterBody2D

var isPouncing = false
var pounceVelocity = Vector2.ZERO
@export var walkSpeed = 50
@export var pounceSpeed = 400
var bounceTimer = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if (!isPouncing and Input.is_action_just_pressed("pounce")):
		update_pounce()
	update_position(delta)
	var collided = move_and_slide()
	if (isPouncing and collided):
		isPouncing = false
		bounceTimer = 0.15


func update_pounce():
	isPouncing = true
	var mouse_pos = get_node("Camera2D").get_global_mouse_position()
	pounceVelocity = mouse_pos - position
	pounceVelocity = pounceVelocity.normalized()
	pounceVelocity *= pounceSpeed


func update_position(delta):
	if (isPouncing):
		velocity = pounceVelocity
		return
		
	if (bounceTimer > 0):
		bounceTimer -= delta
		velocity = -pounceVelocity/5
		return
	
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
