extends AIController
class_name AIVertical

@export var move_down_first: bool = true  # Arah awal

var moving_down: bool = true

func _ready():
	super._ready()
	moving_down = move_down_first

func setup_patrol():
	# Setup target atas atau bawah
	if moving_down:
		target_position = start_position + Vector2(0, patrol_distance)
	else:
		target_position = start_position + Vector2(0, -patrol_distance)

func patrol_movement(delta: float):
	# Gerak ke target
	var direction = (target_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

	# Cek udah sampai target belum
	if reached_target():
		# Balik arah
		moving_down = !moving_down
		if moving_down:
			target_position = start_position + Vector2(0, patrol_distance)
		else:
			target_position = start_position + Vector2(0, -patrol_distance)

		# Tunggu sebentar
		start_waiting()
