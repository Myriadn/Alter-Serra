extends Node2D

@onready var dialog_control = $CanvasLayer/DialogueControl
@onready var level_manager = $LevelManager
@onready var player = $Player
@onready var spawn_point = $Kasur/Marker2D

var dialog_finished_first: bool = false

func _ready():
	player.global_position = spawn_point.global_position
	# Disable player movement saat dialog
	player.set_physics_process(false)

	# Connect signals
	dialog_control.dialog_finished.connect(_on_dialog_finished)
	level_manager.all_tasks_completed.connect(_on_tasks_completed)

	# Start opening dialog
	dialog_control.play_dialog("res://dialogue-data/data-ready/Dialogue - Day 1 Wake Up.json")

func _on_dialog_finished():
	if not dialog_finished_first:
		# Dialog pertama selesai → mulai gameplay
		dialog_finished_first = true
		print("📢 Dialog selesai, mulai gameplay!")
		player.set_physics_process(true)  # Enable player movement
		# LevelManager akan spawn tasks
	else:
		# Dialog kedua selesai → next scene
		print("📢 Scene selesai, ke scene berikutnya!")
		DayManager.next_scene()

func _on_tasks_completed():
	print("✅ Semua tasks selesai!")
	# Play dialog "Go Work" setelah bersih-bersih
	dialog_control.play_dialog("res://dialogue-data/data-ready/Dialogue - Day 1 Go Work.json")
