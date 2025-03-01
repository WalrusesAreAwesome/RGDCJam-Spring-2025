class_name player_controller extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

@export var walkSpeed = 75
@export var pounceSpeed = 400

var isPouncing = false
var pounceVelocity = Vector2.ZERO
var bounceTimer = 0
var pounceTimer = 0

signal on_death




func _physics_process(delta: float) -> void:
	if (!isPouncing and Input.is_action_just_pressed("pounce") and pounceTimer <= 0):
		update_pounce()
		
	update_velocity(delta)
	flip_sprite_right_way()
	var collided = move_and_slide()
	
	if (isPouncing and collided):
		isPouncing = false
		_animated_sprite.play("walkin")
		pounceTimer = 0.4
		bounceTimer = 0.15

func flip_sprite_right_way():
	if (velocity.x < 0):
		_animated_sprite.flip_h = true
	if (velocity.x > 0):
		_animated_sprite.flip_h = false


func update_pounce():
	isPouncing = true
	_animated_sprite.play("pounce")
	var mouse_pos = get_node("Camera2D").get_global_mouse_position()
	pounceVelocity = mouse_pos - position
	pounceVelocity = pounceVelocity.normalized()
	pounceVelocity *= pounceSpeed


func update_velocity(delta):
	if (isPouncing):
		velocity = pounceVelocity
		return
		
	if (bounceTimer > 0):
		bounceTimer -= delta
		velocity = -pounceVelocity/5
		if (bounceTimer <= 0):
			_animated_sprite.stop()
		return
		
	if (pounceTimer > 0):
		pounceTimer -= delta
	
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
	
	if (frameVelocity.length_squared() > 0):
		_animated_sprite.play("walkin")
	else:
		_animated_sprite.stop()
	
	velocity = frameVelocity.normalized() * walkSpeed



# kill the player
func die():
	on_death.emit()
	visible = false
