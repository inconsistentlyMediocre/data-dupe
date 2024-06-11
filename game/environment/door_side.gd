@tool
class_name DoorSide
extends CharacterBody2D


@onready var sprite: Sprite2D = $Sprite2D


func change_color(color: Color) -> void:
	sprite.material.set_shader_parameter("new", color)
