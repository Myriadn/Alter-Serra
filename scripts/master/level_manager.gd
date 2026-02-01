extends Node
class_name LevelManager

signal all_tasks_completed

var active_tasks: Array = []
var completed_tasks: int = 0
var box_seats: Array = []
var filled_box_seats: int = 0
var total_tasks_for_day: int = 0

func _ready():
	await get_tree().process_frame
	connect_existing_tasks()
	connect_existing_box_seats()
	connect_interactables()

func connect_interactables():
	"""Connect furniture/interactables (wardrobe, dll)"""
	var interactables = get_tree().get_nodes_in_group("interactables")

	for obj in interactables:
		# Check if has task_completed signal
		if obj.has_signal("task_completed"):
			obj.task_completed.connect(_on_interactable_task_completed)
			total_tasks_for_day += 1

			var obj_name = obj.furniture_name if obj.get("furniture_name") else obj.name
			print("🛋️ Found interactable: ", obj_name)

func _on_interactable_task_completed():
	completed_tasks += 1
	print("✅ Interactable task done! (", completed_tasks, "/", total_tasks_for_day, ")")
	check_level_complete()


func connect_existing_tasks():
	"""Find semua tasks yang udah di-taro di scene oleh tim desain"""
	var existing_tasks = get_tree().get_nodes_in_group("tasks")

	for task in existing_tasks:
		# Connect signal untuk track completion
		task.tree_exiting.connect(_on_task_completed.bind(task.task_type))
		active_tasks.append(task)

	total_tasks_for_day = active_tasks.size()

	print("📋 Found ", active_tasks.size(), " tasks in scene")
	print("📊 Total tasks for day: ", total_tasks_for_day)

func connect_existing_box_seats():
	"""Find semua box_seats yang udah di-taro di scene"""
	var existing_seats = get_tree().get_nodes_in_group("box_seats")

	for seat in existing_seats:
		if seat is BoxSeat:
			box_seats.append(seat)
			seat.item_placed_correctly.connect(_on_box_seat_filled)
			print("📍 Found box seat at: ", seat.global_position)

func _on_task_completed(task_type: int):
	active_tasks = active_tasks.filter(func(t): return is_instance_valid(t))

	# Type 2 (BOX) = PICKABLE → count pas ditaruh ke box_seat
	if task_type != 2:
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
	if total_tasks_for_day == 0:
		return 100.0
	return (float(completed_tasks) / float(total_tasks_for_day)) * 100.0
