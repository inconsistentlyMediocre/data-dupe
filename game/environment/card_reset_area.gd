@tool
extends Area2D


const BASE_PARTICLES_AMOUNT: int = 16
const BASE_PARTICLES_EXTENTS_SIZE: Vector2i = Vector2i(16, 16)

@export var collision_shape: CollisionShape2D
@export var resize_particles: bool  = false:
	set(value):
		resize_particle_area()
		resize_particles = false

var initial_position: Vector2 = Vector2.ZERO

@onready var particles: CPUParticles2D = $CPUParticles2D


func _ready() -> void:
	initial_position = global_position
	resize_particle_area()


func resize_particle_area() -> void:
	if not is_instance_valid(collision_shape):
		particles.global_position = initial_position
		particles.emission_rect_extents = BASE_PARTICLES_EXTENTS_SIZE
		particles.amount = BASE_PARTICLES_AMOUNT
	particles.global_position = collision_shape.global_position
	particles.emission_rect_extents = collision_shape.shape.size / 2
	particles.amount = round((particles.emission_rect_extents.x * particles.emission_rect_extents.y) / BASE_PARTICLES_AMOUNT)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.color != Door.Colors.NONE:
			body.color = Door.Colors.NONE
			body.camera.apply_shake(5.0)
