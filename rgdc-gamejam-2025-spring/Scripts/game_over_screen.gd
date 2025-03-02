extends CanvasLayer


var game: game_controller




func _ready() -> void:
	game = get_tree().root.get_child(0)




## button functions ##


func restart_game():
	game.open_game()


func quit_game():
	game.quit_game()




## signal functions ##


func show_self():
	visible = true
