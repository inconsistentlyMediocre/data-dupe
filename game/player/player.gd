class_name Player
extends CharacterBody2D


@export var color: Door.Colors:
	set(value):
		color = value
		set_color()
	get:
		return color

var speed: float = 100.0
var direction: Vector2 = Vector2.DOWN
var can_move: bool = true

@onready var card: Sprite2D = $Card
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera: PlayerCamera = $Camera2D


func _ready() -> void:
	GameState.player = self


func _physics_process(delta: float) -> void:
	if not can_move:
		animation_player.stop()
		return
	var input_dir = Input.get_vector("left", "right", "up", "down").normalized()
	
	velocity = input_dir * speed
	if input_dir != Vector2.ZERO:
		direction = input_dir
		match input_dir:
			Vector2.RIGHT:
				animation_player.play("run_right")
			Vector2.LEFT:
				animation_player.play("run_left")
			Vector2.DOWN:
				animation_player.play("run_down")
			Vector2.UP:
				animation_player.play("run_up")
		if velocity.x != 0 and velocity.y != 0:
			if velocity.y > 0:
				animation_player.play("run_down")
			else:
				animation_player.play("run_up")
	else:
		match direction:
			Vector2.RIGHT:
				animation_player.play("idle_right")
			Vector2.LEFT:
				animation_player.play("idle_left")
			Vector2.DOWN:
				animation_player.play("idle_down")
			Vector2.UP:
				animation_player.play("idle_up")
		if direction.x != 0 and direction.y != 0:
			if direction.y > 0:
				animation_player.play("idle_down")
			else:
				animation_player.play("idle_up")
	
	move_and_slide()


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
	if not is_instance_valid(card):
		return
	card.modulate = color
