extends CharacterBody2D

@onready var interaction_area = $Interactions
@onready var hold_position = $HoldPosition

var held_item: PickupItem = null

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

	if held_item:
		held_item.global_position = hold_position.global_position
