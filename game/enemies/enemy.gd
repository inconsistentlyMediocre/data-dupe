@tool
class_name Enemy
extends CharacterBody2D


signal caught_player

@export var color: Door.Colors:
	set(value):
		color = value
		set_color()
	get:
		return color

@export var path: Path2D
@export var is_running: bool = false
@export var sweeping_raycast: RayCast2D

var speed: float = 100.0
var direction: Vector2 = Vector2.DOWN

var positions: Array[Vector2]
var temp_positions: Array[Vector2]
var current_position: Vector2
var move_direction: Vector2 = Vector2.ZERO

# View Cone variables
var vision_angle: float = deg_to_rad(60.0)
var max_view_distance: float = 60.0
var angle_between_rays: float = deg_to_rad(2.0)
var visibility_points: PackedVector2Array

@onready var sprite: Sprite2D = $Sprite2D
@onready var vision_pivot: Node2D = $VisionPivot
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	if not Engine.is_editor_hint():
		is_running = true
		if not is_instance_valid(sweeping_raycast):
			generate_raycasts()
	caught_player.connect(GameState.game_over)
	set_color()
	if is_instance_valid(path):
		for point_index in range(path.curve.point_count):
			positions.append(path.curve.get_point_position(point_index))
		get_positions()
		get_next_position()


func _physics_process(delta: float) -> void:
	if is_instance_valid(sweeping_raycast):
		sweep_raycast()
	if is_running:
		velocity = move_direction * 50
		move_and_slide()
		
		if global_position.distance_to(current_position) < 1:
			get_next_position()
			vision_pivot.look_at(current_position)
		match direction:
			Vector2.UP:
				animation_player.play("floating_up")
			Vector2.DOWN:
				animation_player.play("floating_down")
			Vector2.RIGHT:
				animation_player.play("floating_right")
			Vector2.LEFT:
				animation_player.play("floating_left")


func _process(delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	#get_cone_points()
	if visibility_points.size() < 3:
		return
	draw_polygon(visibility_points, [sprite.material.get_shader_parameter("new")])


func get_cone_points() -> void:
	visibility_points.clear()
	visibility_points.append(Vector2.ZERO)
	var ray_count: int = round(vision_angle / angle_between_rays)
	for index in ray_count:
		var angle: float = angle_between_rays * (index - ray_count / 2.0)
		visibility_points.append((vision_pivot.position + Vector2.RIGHT.rotated(angle) * max_view_distance).rotated(vision_pivot.rotation))


func generate_raycasts() -> void:
	var ray_count: int = round(vision_angle / angle_between_rays)
	for index in ray_count:
		var ray: RayCast2D = RayCast2D.new()
		var angle: float = angle_between_rays * (index - ray_count / 2.0)
		ray.target_position = Vector2.RIGHT.rotated(angle) * max_view_distance
		vision_pivot.add_child(ray)


func sweep_raycast() -> void:
	visibility_points.clear()
	visibility_points.append(Vector2.ZERO)
	
	var cast_count: int = round(vision_angle / angle_between_rays) + 1
	for index in cast_count:
		var angle: float = angle_between_rays * (index - cast_count / 2.0)
		var cast_vector: Vector2 = (max_view_distance * Vector2.RIGHT.rotated(angle))
		sweeping_raycast.target_position = cast_vector
		
		sweeping_raycast.force_raycast_update()
		if sweeping_raycast.is_colliding():
			visibility_points.append(to_local(sweeping_raycast.get_collision_point()))
			if sweeping_raycast.get_collider() is Player:
				caught_player.emit()
				is_running = false
		else:
			visibility_points.append((vision_pivot.position + Vector2.RIGHT.rotated(angle) * max_view_distance).rotated(vision_pivot.rotation))


func get_positions() -> void:
	temp_positions = positions.duplicate()


func get_next_position() -> void:
	if temp_positions.is_empty():
		get_positions()
	current_position = temp_positions.pop_front()
	move_direction = to_local(current_position).normalized()
	direction = Vector2(round(move_direction.x), round(move_direction.y))


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
