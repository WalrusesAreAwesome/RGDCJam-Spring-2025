class_name melee_enemy extends enemy


@export var move_speed: float
@export var avoidance_factor: float
@export var avoidance_dist: float
var avoidance_area: ShapeCast2D

@export var charge_time: float
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

signal on_start_charging
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


func _process(delta: float) -> void:
	super(delta)
	
	# check if near player
	check_near_player()
	
	# if grabbed, dont do anything
	if is_grabbed:
		stop_charging()
	
	else:
		# update charging
		if near_player:
			charging = true
		
		# update various numbers
		charge_attack(delta)
		update_gradient()
		
		# try to attack
		if near_player:
			try_attack()




## attacking functions ##


func check_near_player():
	var dist_to_player = player.position.distance_squared_to(position)
	near_player = dist_to_player <= attack_dist


func charge_attack(delta: float):
	if charging:
		# start the charging
		if time_spent_charging == 0:
			start_charging()
		time_spent_charging += delta
	else:
		time_spent_charging = 0


func start_charging():
	on_start_charging.emit()
	sprite_anim.play(start_charging_anim) 
	show_attack_area()


func stop_charging():
	charging = false


func try_attack():
	if time_spent_charging >= charge_time:
		on_attack.emit()
		sprite_anim.play(attack_anim)
		player.die()
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
	charging = false
	hide_attack_area()
