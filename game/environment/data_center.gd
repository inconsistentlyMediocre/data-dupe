@tool
class_name DataCenter
extends StaticBody2D


@export var color: Door.Colors:
	set(value):
		color = value
		set_color()

var can_interact: bool = false
var player: Player = null

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	set_color()


func _process(delta: float) -> void:
	if can_interact:
		if Input.is_action_just_pressed("action"):
			if not player == null:
				player.color = color


func set_color() -> void:
	match color:
		Door.Colors.NONE:
			change_color(Color.WHITE)
		Door.Colors.BLUE:
			change_color(Color("2255b4"))
		Door.Colors.RED:
			change_color(Color("b42222"))
		Door.Colors.GREEN:
			change_color(Color("22b422"))


func change_color(color: Color) -> void:
	if not is_instance_valid(sprite):
		return
	sprite.material.set_shader_parameter("new", color)


func _on_activation_area_body_entered(body: Node2D) -> void:
	if body is Player:
		can_interact = true
		player = body


func _on_activation_area_body_exited(body: Node2D) -> void:
	if body is Player:
		can_interact = false
		player = null
