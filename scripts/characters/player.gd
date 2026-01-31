extends CharacterBody2D
class_name Player

@onready var interaction_area = $Node2D/Interactions
@onready var hold_position = $HoldPosition
@onready var drop_position: Marker2D = $DropPosition
@onready var interact_pivot: Node2D = $interactPivot

@onready var sprite = $Sprite2D
@onready var color_rect = $Sprite2D/ColorRect
@onready var anim: AnimationPlayer = $anim
@onready var timer_cleansing: Timer = $TimerCleansing
@onready var cleansing_progress: TextureProgressBar = $CleansingProgress

const HOLD_INTSANCE = preload("uid://coj5g74jgljvy")
const TASK_CLEANING = preload("uid://7tiq4dsm2ktv")

var held_item
var facing_direction = Vector2.DOWN
var is_moving = false
var is_cleansing = false
var is_holding = false
var available_drop_place

const SPEED = 100.0

func _ready() -> void:
	cleansing_progress.hide()

func _input(event):
	if event.is_action_pressed("interact"):
		if held_item:
			drop_item()
		else:
			interact()

func interact():
	if is_holding or is_cleansing:
		return

	for body in obj_touched:
		# Check if cleanable (NODA, BARANG)
		if body.has_method("can_be_cleaned") and body.can_be_cleaned():
			cleansing(body)
			break

		# Check if pickable (BOX, RACK)
		elif body.has_method("can_be_picked") and body.can_be_picked():
			pickup_item(body)
			break


func pickup_item(body):
	print("📦 Picking up: ", body.task_name.keys()[body.task_type])

	var inst = HOLD_INTSANCE.instantiate()
	held_item = inst
	inst.obj_name = body.task_name.keys()[body.task_type]

	# Set texture based on type (bisa pakai dictionary nanti)
	var texture_uid = get_pickup_texture_uid(body)
	inst.image = load(texture_uid)

	hold_position.add_child(inst)
	body.pick_box(self)
	is_holding = true

func get_pickup_texture_uid(body) -> String: # texture uid getter
	if body.has_method("get_task_name_string"):
		match body.get_task_name_string():
			"BOX":
				return "uid://5jwrcqoqsm4i"
			"RACK":
				return "uid://cro2141m6rpk7"
			_:
				return "uid://5jwrcqoqsm4i"  # Default
	return ""

var clean_timer = 0.0
var saved_objek_interact

func cleansing(objek):
	var durasi = objek.cleaning_duration
	_set_cleansing_state(true)
	cleansing_progress.max_value = durasi
	objek.cleansing()
	saved_objek_interact = objek
	anim.play("CLEANING " + objek.task_name.keys()[objek.task_type])

func force_stop_cleansing():
	if saved_objek_interact:
		_set_cleansing_state(false)
		saved_objek_interact.do_failure()
		clean_timer = 0.0
		saved_objek_interact = null

func _set_cleansing_state(state : bool):
	if state :
		timer_cleansing.start()
	else :
		timer_cleansing.stop()
		clean_timer = 0.0
	is_cleansing = state
	cleansing_progress.visible = state

func drop_item():
	if not is_holding or not held_item:
		return

	var item_name = "BOX"  # Default
	if held_item.get("obj_name"):
		item_name = held_item.obj_name
	elif held_item is Node and held_item.has_method("get"):
		item_name = held_item.get("obj_name") if held_item.get("obj_name") else "BOX"

	print("🎯 Trying to drop: ", item_name)

	# Check jika ada box_seat nearby
	if available_drop_place:
		print("📍 Drop place detected: ", available_drop_place.name)

		# Check jika box_seat
		if available_drop_place is BoxSeat:
			if available_drop_place.can_place_item(item_name):
				# Place di box_seat
				available_drop_place.set_item(true)

				# Clear held item
				is_holding = false
				for i in hold_position.get_children():
					if i.has_method("_clear_holder"):
						i._clear_holder()

				print("✅ Item placed in box seat!")
				return
			else:
				print("❌ Cannot place ", item_name, " in this box seat")
				return

	# Fallback: Drop di tempat random
	print("📦 Dropping at position (no box seat)")
	var inst = TASK_CLEANING.instantiate()
	inst.task_type = get_task_type_from_name(item_name)
	inst.global_position = drop_position.global_position
	get_parent().add_child(inst)

	# Clear held item
	is_holding = false
	for i in hold_position.get_children():
		if i.has_method("_clear_holder"):
			i._clear_holder()

func get_task_type_from_name(name: String) -> int:
	match name:
		"BOX": return 2
		"RACK": return 3
		"BARANG": return 1
		"NODA": return 0
		_: return 2

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	velocity = direction * SPEED
	move_and_slide()

	if direction != Vector2.ZERO:
		update_facing_direction(direction)
		if !is_moving:
			is_moving = true
			if saved_objek_interact : force_stop_cleansing()
	else :
		if is_moving: is_moving = false

	if held_item:
		held_item.global_position = hold_position.global_position
	if is_cleansing:
		cleansing_progress.value = clean_timer

func update_facing_direction(direction: Vector2):
	facing_direction = direction

	# Tentukan arah dominan (4-directional: up, down, left, right)
	var offset_distance = 16  # Jarak item dari player (adjust sesuai size sprite)

	if abs(direction.x) > abs(direction.y):
		# Horizontal movement (left/right)
		if direction.x > 0:
			# Ngadep kanan
			sprite.scale.x = abs(sprite.scale.x)
			interact_pivot.rotation_degrees = 0
			hold_position.position = Vector2(offset_distance, 0)
			drop_position.position = Vector2(offset_distance + 10, 0)
		else:
			# Ngadep kiri
			sprite.scale.x = -abs(sprite.scale.x)
			interact_pivot.rotation_degrees = 180
			hold_position.position = Vector2(-offset_distance, 0)
			drop_position.position = Vector2(-offset_distance - 10, 0)
	else:
		# Vertical movement (up/down)
		if direction.y > 0:
			# Ngadep bawah
			sprite.scale.x = abs(sprite.scale.x)  # Reset flip
			interact_pivot.rotation_degrees = 90
			hold_position.position = Vector2(0, offset_distance)
			drop_position.position = Vector2(0, offset_distance + 10)
		else:
			# Ngadep atas
			sprite.scale.x = abs(sprite.scale.x)  # Reset flip
			interact_pivot.rotation_degrees = -90
			hold_position.position = Vector2(0, -offset_distance)
			drop_position.position = Vector2(0, -offset_distance - 10)


var obj_touched = []

func _on_interactions_area_entered(area: Area2D) -> void:
	if area: if is_instance_valid(area):
		obj_touched.append(area)
	check_for_bodies()

func _on_interactions_area_exited(area: Area2D) -> void:
	if area: if is_instance_valid(area):
		obj_touched.erase(area)
	check_for_bodies()


func _on_interactions_body_entered(body: Node2D) -> void:
	if body: if is_instance_valid(body):
		obj_touched.append(body)
	check_for_bodies()

func _on_interactions_body_exited(body: Node2D) -> void:
	if body: if is_instance_valid(body):
		obj_touched.erase(body)
	check_for_bodies()

func check_for_bodies():
	for i in obj_touched:
		if !is_instance_valid(i):
			obj_touched.erase(i)

func _on_timer_timeout() -> void:
	clean_timer += 0.1
	if saved_objek_interact: if clean_timer >= saved_objek_interact.cleaning_duration:
		saved_objek_interact.do_success()
		_set_cleansing_state(false)
