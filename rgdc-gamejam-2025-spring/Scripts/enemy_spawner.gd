class_name enemy_spawner extends Node2D


@export var enemy: PackedScene
@export var spawn_per_second: float 
var time_since_spawn: float = 0




func _process(delta: float) -> void:
	# update timer
	time_since_spawn += delta
	if time_since_spawn >= 1 / spawn_per_second:
		time_since_spawn = 0
		
		# spawn enemy add as child of the spawner's parent
		var spawned_enemy = enemy.instantiate()
		get_parent().add_child(spawned_enemy)
		# set pos of enemy to spawner pos
		spawned_enemy.position = position
