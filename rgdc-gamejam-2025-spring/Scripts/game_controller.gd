extends Node


var main_menu_path = "res://Scenes/MainMenu.tscn"
var game_path = "res://Scenes/Game.tscn"
var pause_menu_path = "res://Scenes/"



# when app starts, create main menu
func _ready() -> void:
	open_main_menu()



## handling scenes ##


# open main menu scene
func open_main_menu():
	set_child_from_path(main_menu_path)



# open game scene
func open_game():
	set_child_from_path(main_menu_path)



# pause game
func open_pause_menu():
	set_child_from_path(main_menu_path)



# load scene and set as child from given path
func set_child_from_path(path: String):
	var scene = load(path).instantiate()
	# remove all current children
	for child in get_children():
		child.queue_free()
		remove_child(child)
	# add new scene as child
	add_child(scene)
