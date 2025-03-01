class_name main_menu_controller extends Node


var game: game_controller


func _ready() -> void:
	# store game controller
	game = get_tree().root.get_child(0)




## buttons funcs ##


func start_game() -> void:
	game.open_game()


func quit_game() -> void:
	game.quit_game()
