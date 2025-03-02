class_name melee_enemy extends enemy


@export var base_move_speed: float
var move_speed: float
@export var avoidance_factor: float
@export var avoidance_dist: float
var avoidance_area: ShapeCast2D

@export var base_charge_time: float
var charge_time: float
@export var attack_dist: float
var near_player: bool
var time_spent_charging: float
var charging: bool

var start_charging_anim = "start_charging"
var attack_anim = "attack"
var walk_anim = "walk"
var grabbed_anim = "grabbed"
var idle_anim = "idle"
var sprite_anim: AnimatedSprite2D 

var melee_sprite: Sprite2D
var melee_area: Area2D
var attack_dir: Vector2
var pivot: Node2D
@export var charge_gradient: Gradient

@export var charge_scaling_factor: float
@export var speed_scaling_factor: float

var game: game_controller

signal on_start_charging
signal on_stop_charging
signal on_attack



## built in overrides ##


func _ready() -> void:
	super()
	sprite_anim = get_node("AnimatedSprite2D")
	melee_sprite = get_node("Pivot/Melee Area/Sprite2D")
	melee_area = get_node("Pivot/Melee Area")
	pivot = get_node("Pivot")
	# get avoidance area & set based on stored var
	avoidance_area = get_node("Avoidance Area")
	avoidance_area.scale *= avoidance_dist
	#get and store game controller
	game = get_tree().root.get_child(0)


func _process(delta: float) -> void:
	super(delta)
	
	scale_power()
	
	# if grabbed, dont do anything
	if !is_grabbed:
		
		# check if near player
		var now_near_player = check_near_player()
		if now_near_player != near_player:
			near_player = now_near_player
			if near_player:
				start_charging()
			else:
				stop_charging()
		
		# update various numbers
		if charging:
			time_spent_charging += delta
			update_gradient()
		
		# try to attack
		if near_player:
			try_attack()




## power scalng factor ##


func scale_power():
	if game.game_scene != null:
		var round_duration = game.game_scene.round_duration
		move_speed = base_move_speed + round_duration * speed_scaling_factor
		charge_time = base_charge_time - round_duration * charge_scaling_factor
		if charge_time < 0.1:
			charge_time = 0.1
	else:
		print("warning! no game_scene_controller found!")




## attacking functions ##


func check_near_player() -> bool:
	var dist_to_player = player.position.distance_squared_to(position)
	return dist_to_player <= attack_dist


func start_charging():
	charging = true
	on_start_charging.emit()
	sprite_anim.play(start_charging_anim) 
	time_spent_charging = 0
	show_attack_area()


func stop_charging():
	on_stop_charging.emit()
	charging = false
	hide_attack_area()


func try_attack():
	if time_spent_charging >= charge_time:
		on_attack.emit()
		sprite_anim.play(attack_anim)
		player.die()
		time_spent_charging = 0
		stop_charging()


func update_gradient():
	melee_sprite.modulate = charge_gradient.sample(time_spent_charging / charge_time)




## attack area ##


func show_attack_area():
	# rotate melee area towards player
	attack_dir = (player.position - position).normalized()
	pivot.look_at(player.position) 
	# unhide sprite
	melee_sprite.visible = true


func hide_attack_area():
	# hide sprite
	melee_sprite.visible = false




## movement functions ##


func movement():
	# if not near player, move towards player. else stand still
	if near_player:
		velocity = Vector2.ZERO
	
	# otherwise move towards player
	else:
		sprite_anim.play(walk_anim)
		# point to player
		var dir_to_player: Vector2 = player.position - position
		velocity = dir_to_player.normalized() * move_speed
		# avoid other enemies
		velocity += avoidance()


func avoidance() -> Vector2:
	
	# get nearby enemies from circlecast
	var avoidance: Vector2 = Vector2.ZERO
	for index in range(0,avoidance_area.get_collision_count()):
		# skip if collider is null
		if avoidance_area.get_collider(index) == null:
			continue
		var collider_pos = avoidance_area.get_collider(index).position
		var dist = position.distance_to(collider_pos)
		
		# apply linear falloff based on dist
		var scaled_dist = dist / avoidance_dist
		avoidance += (1 - scaled_dist) * (position - collider_pos)
	
	# return amnt * avoidance factor
	return avoidance




## grab functions ##


func start_grab():
	sprite_anim.play(grabbed_anim)
	# stop attacking
	stop_charging()
