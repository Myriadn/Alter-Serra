extends Node2D
class_name BaseLevel

# References (auto dari template)
@onready var dialog_control = $UI/DialogueControl
@onready var level_manager = $LevelManager
@onready var player = $Player
@onready var spawn_point = $SpawnPoint

# Config per level (override di child script)
@export var dialog_intro: String = ""      # Dialog awal
@export var dialog_outro: String = ""      # Dialog setelah selesai
@export var next_scene: String = ""        # Scene berikutnya

var is_intro_done: bool = false
var is_gameplay_done: bool = false

func _ready():
	await get_tree().process_frame

	# Setup
	if spawn_point:
		player.global_position = spawn_point.global_position

	player.set_physics_process(false)

	# Connect signals
	dialog_control.dialog_finished.connect(_on_dialog_finished)
	level_manager.all_tasks_completed.connect(_on_tasks_completed)

	# Play intro dialog
	if dialog_intro != "":
		print("🎭 Playing intro dialog: ", dialog_intro)
		dialog_control.play_dialog(dialog_intro)
	else:
		# Skip ke gameplay
		_start_gameplay()

func _on_dialog_finished():
	if not is_intro_done:
		# Intro selesai → mulai gameplay
		_start_gameplay()
	else:
		# Outro selesai → next scene
		_go_to_next_scene()

func _start_gameplay():
	is_intro_done = true
	print("🎮 Gameplay started!")
	player.set_physics_process(true)

func _on_tasks_completed():
	print("✅ All tasks completed!")
	is_gameplay_done = true
	player.set_physics_process(false)

	# Play outro dialog
	if dialog_outro != "":
		print("🎭 Playing outro dialog: ", dialog_outro)
		dialog_control.play_dialog(dialog_outro)
	else:
		# Skip ke next scene
		_go_to_next_scene()

func _go_to_next_scene():
	print("➡️ Going to next scene: ", next_scene)
	if next_scene != "":
		DayManager.go_to_scene(next_scene)
	else:
		print("⚠️ No next scene defined!")
