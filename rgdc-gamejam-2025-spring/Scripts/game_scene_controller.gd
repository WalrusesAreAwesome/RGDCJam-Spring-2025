## different from game_controller, this one manages just the Game.tscn scene, while game_controller manages the
## entire game
class_name game_scene_controller extends Node2D



var player_path = "res://Scenes/Player.tscn"
var game: game_controller
var player: player_controller




func _ready() -> void:
	# get game_controller
	game = get_tree().root.get_child(0)


func _process(delta: float) -> void:
	pass




## functions for managing the in-game events
