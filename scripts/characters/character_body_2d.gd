extends CharacterBody2D

@onready var interaction_area = $Interactions
@onready var hold_position = $HoldPosition
@onready var sprite = $Sprite2D
@onready var color_rect = $Sprite2D/ColorRect

var held_item: PickupItem = null
var facing_direction = Vector2.DOWN

const SPEED = 100.0

func _input(event):
	if event.is_action_pressed("interact"):
		if held_item:
			drop_item()
		else:
			pick_up_item()

func pick_up_item():
	var areas = interaction_area.get_overlapping_bodies()
	for body in areas:
		if body is PickupItem:
			held_item = body
			held_item.is_held = true
			# Matikan collision barang agar tidak ganggu pergerakan
			held_item.get_node("CollisionShape2D").disabled = true
			break

func drop_item():
	if held_item:
		held_item.is_held = false
		held_item.get_node("CollisionShape2D").disabled = false
		held_item = null

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	velocity = direction * SPEED
	move_and_slide()

	if direction != Vector2.ZERO:
		update_facing_direction(direction)

	if held_item:
		held_item.global_position = hold_position.global_position

func update_facing_direction(direction: Vector2):
	facing_direction = direction

	# Flip sprite horizontal untuk kiri/kanan
	if direction.x > 0:
		# Ngadep kanan
		sprite.scale.x = abs(sprite.scale.x)  # Positive = normal
		# Pindah interaction area & hold position ke kanan
		interaction_area.position.x = abs(interaction_area.position.x)
		hold_position.position.x = abs(hold_position.position.x)
	elif direction.x < 0:
		# Ngadep kiri
		sprite.scale.x = -abs(sprite.scale.x)  # Negative = flipped
		# Pindah interaction area & hold position ke kiri
		interaction_area.position.x = -abs(interaction_area.position.x)
		hold_position.position.x = -abs(hold_position.position.x)
