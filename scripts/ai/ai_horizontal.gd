extends AIController
class_name AIHorizontal

@export var move_right_first: bool = true  # Arah awal

var moving_right: bool = true

func _ready():
	super._ready()
	moving_right = move_right_first

func setup_patrol():
	# Setup target kiri atau kanan
	if moving_right:
		target_position = start_position + Vector2(patrol_distance, 0)
	else:
		target_position = start_position + Vector2(-patrol_distance, 0)

func patrol_movement(delta: float):
	# Gerak ke target
	var direction = (target_position - global_position).normalized()
	velocity = direction * speed

	# Flip sprite sesuai arah
	if has_node("Sprite2D"):
		var sprite = get_node("Sprite2D")
		if direction.x > 0:
			sprite.scale.x = abs(sprite.scale.x)
		elif direction.x < 0:
			sprite.scale.x = -abs(sprite.scale.x)

	# Cek udah sampai target belum
	if reached_target():
		# Balik arah
		moving_right = !moving_right
		if moving_right:
			target_position = start_position + Vector2(patrol_distance, 0)
		else:
			target_position = start_position + Vector2(-patrol_distance, 0)

		# Tunggu sebentar
		start_waiting()
