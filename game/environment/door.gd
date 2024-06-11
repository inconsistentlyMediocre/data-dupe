@tool
class_name Door
extends Node2D


enum Colors {
	NONE,
	BLUE,
	RED,
	GREEN,
}

@export var color: Colors:
	set(value):
		color = value
		set_color()

var can_open: bool = false
var is_open: bool = false
var door_sides: Array[DoorSide]
var in_range: Array[CharacterBody2D]

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var door_left: DoorSide = $DoorLeft
@onready var door_right: DoorSide = $DoorRight


func _ready() -> void:
	door_sides = [door_left, door_right]
	set_color()


func set_color() -> void:
	match color:
		Door.Colors.NONE:
			can_open = true
			change_color(Color.WHITE)
		Door.Colors.BLUE:
			change_color(Color("2255b4"))
		Door.Colors.RED:
			change_color(Color("b42222"))
		Door.Colors.GREEN:
			change_color(Color("22b422"))


func change_color(color: Color) -> void:
	for door_side in door_sides:
		door_side.change_color(color)


func _on_detect_area_body_entered(body: Node2D) -> void:
	if body is Player or body is Enemy:
		in_range.append(body)
		can_open = body.color == color
		if not can_open or is_open:
			return
		animation_player.play("open")
		is_open = true


func _on_detect_area_body_exited(body: Node2D) -> void:
	if body is Player or body is Enemy:
		in_range.erase(body)
		if in_range.is_empty() and can_open:
			animation_player.play_backwards("open")
			is_open = false
