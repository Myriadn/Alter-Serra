extends Node

signal scene_changing(next_scene: String)

# Urutan scenes (hardcode aja)
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
	go_to_scene(SCENE_ORDER[0])

func next_scene():
	current_scene_index += 1

	if current_scene_index >= SCENE_ORDER.size():
		print("GAME COMPLETE!")
		# Balik ke main menu atau show credits
		get_tree().change_scene_to_file("res://scenes/main menu/Main Menu.tscn")
		return

	var next = SCENE_ORDER[current_scene_index]
	print("Next scene: ", next)
	go_to_scene(next)

func go_to_scene(scene_path: String):
	scene_changing.emit(scene_path)
	get_tree().change_scene_to_file(scene_path)

# Untuk bad ending (Day 2 pilihan 2)
func bad_ending():
	print("Bad ending!")
	get_tree().change_scene_to_file("res://scenes/levels/bad_ending.tscn")

# Untuk skip ke scene tertentu (debug)
func go_to_scene_index(index: int):
	if index >= 0 and index < SCENE_ORDER.size():
		current_scene_index = index
		go_to_scene(SCENE_ORDER[index])
