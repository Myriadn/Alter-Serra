extends Node

signal scene_changing(next_scene: String)

const SCENE_ORDER = [
	"res://scenes/levels/master/day1/day1_morning.tscn",
	"res://scenes/levels/master/day1/day1_night.tscn",
	"res://scenes/levels/master/day2/day2_morning.tscn",
	"res://scenes/levels/master/day2/day2_night.tscn",
	"res://scenes/levels/master/day3/day3_boss.tscn",
	"res://scenes/levels/master/day3/day3_morning.tscn",
	"res://scenes/levels/master/day4/day4_boss.tscn",
	"res://scenes/levels/master/day4/day4_ending.tscn",
]

var current_scene_index: int = 0

func start_game():
	current_scene_index = 0
	go_to_scene_with_day(SCENE_ORDER[0], 1)

func next_scene():
	current_scene_index += 1

	if current_scene_index >= SCENE_ORDER.size():
		print("GAME COMPLETE!")
		SceneManager._change_scene("res://scenes/main menu/Main Menu.tscn")
		return

	var next = SCENE_ORDER[current_scene_index]
	print("Next scene: ", next)

	var show_day_counter = "morning" in next.to_lower()

	if show_day_counter:
		var day_number = _get_day_number_from_index(current_scene_index)
		go_to_scene_with_day(next, day_number)
	else:
		go_to_scene(next)

func go_to_scene(scene_path: String):
	scene_changing.emit(scene_path)
	await SceneManager._change_scene(scene_path)

func go_to_scene_with_day(scene_path: String, day_number: int):
	scene_changing.emit(scene_path)
	await SceneManager._change_scene_w_day_count(scene_path, day_number)

func bad_ending():
	print("Bad ending!")
	await SceneManager._change_scene("res://scenes/levels/bad_ending.tscn")

func go_to_scene_index(index: int):
	if index >= 0 and index < SCENE_ORDER.size():
		current_scene_index = index
		var show_day = "morning" in SCENE_ORDER[index].to_lower()

		if show_day:
			var day_number = _get_day_number_from_index(index)
			go_to_scene_with_day(SCENE_ORDER[index], day_number)
		else:
			go_to_scene(SCENE_ORDER[index])

func _get_day_number_from_index(index: int) -> int:
	if index == 0 or index == 1:
		return 1
	elif index == 2 or index == 3:
		return 2
	elif index == 4 or index == 5:
		return 3
	elif index == 6 or index == 7:
		return 4
	else:
		return 1
