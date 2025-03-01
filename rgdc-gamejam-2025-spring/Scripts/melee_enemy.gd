class_name melee_enemy extends enemy


@export var move_speed: float
@export var attack_dist: float
@export var charge_time: float

var near_player: bool
var time_spent_charging: float

var start_charging_anim = "start_charging"
var attack_anim = "attack"
var walk_anim = "walk"
var grabbed_anim = "grabbed"
var idle_anim = "idle"
var sprite_anim: AnimatedSprite2D 

signal start_charging
signal attack




func _ready() -> void:
	super()
	sprite_anim = get_node("AnimatedSprite2D")


func _process(delta: float) -> void:
	super(delta)
	
	# check if near player
	check_near_player()
	
	# update attack charge
	charge_attack(delta)
	
	# try to attack
	if near_player:
		try_attack()




## attacking functions ##


func check_near_player():
	var dist_to_player = player.position.distance_squared_to(position)
	near_player = dist_to_player <= attack_dist


func charge_attack(delta: float):
	if near_player:
		if time_spent_charging == 0:
			start_charging.emit()
			sprite_anim.play(start_charging_anim) 
		time_spent_charging += delta
	else:
		time_spent_charging = 0


func try_attack():
	if time_spent_charging >= charge_time:
		sprite_anim.play(attack_anim)
		player.die()




## movement functions ##


func movement():
	# if not near player, move towards player. else stand still
	if near_player:
		velocity = Vector2.ZERO
	
	# otherwise move towards player
	else:
		sprite_anim.play(walk_anim)
		var dir_to_player: Vector2 = player.position - position
		velocity = dir_to_player.normalized() * move_speed




## grab functions ##


func start_grab():
	sprite_anim.play(grabbed_anim)
