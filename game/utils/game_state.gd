extends Node


var tutorial_scene: PackedScene = preload("res://game/tutorial.tscn")
var player: Player = null
var has_been_caught: bool = false


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func start_game() -> void:
	get_tree().change_scene_to_packed(tutorial_scene)
	RenderingServer.set_default_clear_color(Color("101010"))


func game_over() -> void:
	if not is_instance_valid(player) or has_been_caught:
		return
	player.camera.apply_shake()
	player.can_move = false
	Gui.game_over()
	has_been_caught = true
