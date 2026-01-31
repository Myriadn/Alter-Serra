extends Node
class_name LevelManager

signal all_tasks_completed

@export var current_day: int = 1
@export var spawn_area_min: Vector2 = Vector2(-200, -100)
@export var spawn_area_max: Vector2 = Vector2(200, 100)

var active_tasks: Array = []
var completed_tasks: int = 0
var box_seats: Array = []
var filled_box_seats: int = 0
var total_tasks_for_day: int = 0

# Task prefab
const TASK_PREFAB = preload("res://scenes/task/task_modular.tscn")
const BOX_SEAT_PREFAB = preload("res://scenes/items/box_seat.tscn")

# Config tasks per day
const DAY_CONFIGS = {
	1: [  # Day 1
		{"type": 0, "count": 2}, # Noda
		{"type": 1, "count": 1}, # Barang
		{"type": 2, "count": 1}, # Barang
	],
	2: [  # Day 2
		{"type": 0, "count": 5},
		{"type": 1, "count": 4},
		{"type": 2, "count": 4},
	],
	3: [  # Day 3
		{"type": 0, "count": 8},
		{"type": 1, "count": 5},
		{"type": 2, "count": 5},
	]
}

func _ready():
	await get_tree().process_frame
	connect_existing_box_seats()
	spawn_tasks_for_day(current_day)

func connect_existing_box_seats():
	var existing_seats = get_tree().get_nodes_in_group("box_seats")
	for seat in existing_seats:
		if seat is BoxSeat:
			box_seats.append(seat)
			seat.item_placed_correctly.connect(_on_box_seat_filled)
			print("📍 Found box seat at: ", seat.global_position)

func spawn_tasks_for_day(day: int):
	print("Spawning tasks for Day ", day)

	if day not in DAY_CONFIGS:
		push_error("No config for day ", day)
		return

	var config = DAY_CONFIGS[day]

	total_tasks_for_day = 0
	for task_config in config:
		total_tasks_for_day += task_config["count"]


	for task_config in config:
		var task_type = task_config["type"]
		var count = task_config["count"]

		for i in range(count):
			spawn_task(task_type)

	print(" Total tasks spawned: ", active_tasks.size())
	print("   - Box seats in scene: ", box_seats.size())


func spawn_task(task_type: int):
	var task = TASK_PREFAB.instantiate()
	task.task_type = task_type

	# Random position
	var random_pos = Vector2(
		randf_range(spawn_area_min.x, spawn_area_max.x),
		randf_range(spawn_area_min.y, spawn_area_max.y)
	)
	task.global_position = random_pos

	# Track completion
	task.tree_exiting.connect(_on_task_completed.bind(task_type))

	# Add to scene
	get_parent().call_deferred("add_child", task)
	active_tasks.append(task)

func _on_task_completed(task_type: int):
	active_tasks = active_tasks.filter(func(t): return is_instance_valid(t))

	# Type 0 (NODA), 1 (BARANG), 3 (RACK) = CLEANABLE → count langsung
	# Type 2 (BOX) = PICKABLE → count pas ditaruh ke box_seat, BUKAN di sini
	if task_type != 2:  # Semua KECUALI BOX
		completed_tasks += 1
		print("✅ Cleaned! (type ", task_type, ") ", completed_tasks, "/", total_tasks_for_day)
	else:
		print("📦 BOX picked up (will count when placed)")

	print("📋 Tasks remaining: ", active_tasks.size())
	check_level_complete()



func _on_box_seat_filled(_box_seat: BoxSeat):
	filled_box_seats += 1
	completed_tasks += 1

	print("✅ Box filled! ", completed_tasks, " | Box seats: ", filled_box_seats, "/", box_seats.size())
	check_level_complete()


func check_level_complete():
	print("📊 Progress: ", completed_tasks, "/", total_tasks_for_day, " | Box: ", filled_box_seats, "/", box_seats.size())

	if completed_tasks >= total_tasks_for_day:
		all_tasks_completed.emit()
		print("🎉 LEVEL COMPLETE!")
	else:
		print("⏳ Remaining: ", total_tasks_for_day - completed_tasks)





func get_progress() -> float:
	var total_tasks = active_tasks.size()

	if total_tasks == 0:
		return 100.0

	var task_progress = float(total_tasks) * 50.0 if total_tasks > 0 else 50.0

	return task_progress
