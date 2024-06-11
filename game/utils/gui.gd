extends CanvasLayer


var can_restart: bool = false

@onready var fade: Control = $Control/Fade
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _input(event: InputEvent) -> void:
	if can_restart:
		if Input.is_action_just_pressed("restart"):
			get_tree().reload_current_scene()
			can_restart = false
			animation_player.play("RESET")
			GameState.has_been_caught = false


func game_over() -> void:
	animation_player.play("game_over")


func warp(scene: PackedScene) -> void:
	animation_player.play("fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_packed(scene)
	animation_player.play_backwards("fade")
	await animation_player.animation_finished


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "game_over":
		can_restart = true
