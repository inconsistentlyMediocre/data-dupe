extends PathFollow2D


@export var guard: Enemy

var is_running: bool = false


func _physics_process(delta: float) -> void:
	if not is_running:
		return
	else:
		progress_ratio += 0.1 * delta
