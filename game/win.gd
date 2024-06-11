extends Control


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("restart"):
		Gui.warp(preload("res://game/main_menu.tscn"))
