class_name test_enemy extends enemy


func movement() -> void:
	# have enemy walk to player
	# no need to use move & slide, already called by base enemy
	var dir_to_player = player.position - position
	velocity = dir_to_player.normalized() * 10.0
