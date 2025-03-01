class_name pause_menu extends CanvasLayer


var is_paused: bool = false
var game: game_controller




# hide self when made and get reference to game_controller
func _ready() -> void:
	enable_pause_menu(false)
	game = get_tree().root.get_child(0)


func _process(_delta: float) -> void:
	# if get input, enable or disable pause menu
	if Input.is_action_just_pressed("ui_cancel"):
		enable_pause_menu(!is_paused)


func enable_pause_menu(enabled: bool) -> void:
	# set visible from given bool
	visible = enabled
	is_paused = enabled




## button functions ##


func resume() -> void:
	enable_pause_menu(false)


func quit_to_menu() -> void:
	game.open_main_menu()


func quit_to_desktop() -> void:
	game.quit_game()
