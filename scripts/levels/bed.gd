extends InteractiveFurniture
class_name Bed

@export var require_all_tasks_done: bool = true

signal sleep_started

var level_manager: LevelManager

func _ready():
	super._ready()

	# Find level manager
	var managers = get_tree().get_nodes_in_group("level_manager")
	if managers.size() > 0:
		level_manager = managers[0]
	else:
		push_warning("LevelManager not found!")

	# Hide hover hint if exists
	if hover_hint:
		hover_hint.hide()

func can_be_interacted() -> bool:
	if not super.can_be_interacted():
		return false

	# Check jika semua tasks selesai
	if require_all_tasks_done and level_manager:
		var tasks_done = level_manager.completed_tasks >= level_manager.total_tasks_for_day
		if not tasks_done:
			print("💤 Belum bisa tidur, beresin dulu!")
		return tasks_done

	return true

func interact():
	if not can_be_interacted():
		return false

	print("😴 Tidur di kasur...")

	super.interact()
	sleep_started.emit()

	return true
