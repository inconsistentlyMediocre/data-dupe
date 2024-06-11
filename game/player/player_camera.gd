class_name PlayerCamera
extends Camera2D


@export var shake_strength: float = 10.0
@export var shake_fade: float = 5.0

var current_shake_strength: float = 0.0


func _process(delta: float) -> void:
	if current_shake_strength > 0.5:
		current_shake_strength = lerpf(current_shake_strength, 0, shake_fade * delta)
		offset = get_shake_offset()


func apply_shake(strength: float = shake_strength) -> void:
	current_shake_strength = strength


func get_shake_offset() -> Vector2:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	return Vector2(rng.randf_range(-current_shake_strength, current_shake_strength), rng.randf_range(-current_shake_strength, current_shake_strength))
