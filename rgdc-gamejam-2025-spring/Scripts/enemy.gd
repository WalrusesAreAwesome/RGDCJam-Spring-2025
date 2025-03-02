## base enemy class. when making an enemy extend from this script to get a bunch of defualt stuff
class_name enemy extends CharacterBody2D




var explosion_path = "res://Scenes/Explosion.tscn"

var player: player_controller
var is_grabbed = false
var offset_from_player: Vector2 # offset used to move w/ player during grab
var grab_area: Area2D

signal on_grabbed
signal on_killed




func _ready() -> void:
	# get and store player
	get_player()
	# store grab area
	for child in get_children():
		if child is Area2D:
			grab_area = child
	grab_area.monitoring = true


func _physics_process(_delta: float) -> void:
	if is_grabbed:
		grab_movement()
	else:
		movement()
		move_and_slide()


func _process(_delta: float) -> void:
	try_not_get_grabbed()




func get_player() -> void:
	var parent = get_parent()
	for child in parent.get_children():
		# if child is player_controller, store it
		if child is player_controller:
			player = child

# become grabbed by the whatever it colldier with
func try_become_grabbed(body):
	if body is player_controller and player.isPouncing:
		is_grabbed = true
		offset_from_player = position - player.position
		on_grabbed.emit()
		start_grab()

# when grabbed, see if can get un-grabbed
func try_not_get_grabbed():
	if !player.isPouncing and is_grabbed:
		is_grabbed = false
		stop_grab()

# how the enemy moves when grabbed by the player`
func grab_movement():
	position = player.position + offset_from_player

func _on_area_2d_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	try_become_grabbed(body)
	if is_grabbed and body is not player_controller:
		die()




func die():
	on_killed.emit()
	var node = load(explosion_path).instantiate()
	node.position = position
	get_parent().add_child(node)
	queue_free()





# how the enemy moves when not grabbed by the player
# overwrite in inherited class
func movement():
	pass

func start_grab():
	pass

func stop_grab():
	pass
