extends Control


var can_start: bool = false

@onready var intro_animation_player: AnimationPlayer = $Intro/AnimationPlayer


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("action") or Input.is_action_just_pressed("ui_accept"):
		intro_animation_player.play("show")
	if can_start and event is InputEventKey:
		GameState.start_game()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "show":
		can_start = true
