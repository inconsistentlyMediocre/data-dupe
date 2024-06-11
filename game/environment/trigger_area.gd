class_name TriggerArea
extends Area2D


@export var scene: PackedScene


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		await get_tree().create_timer(0.5).timeout
		Gui.warp(scene)
