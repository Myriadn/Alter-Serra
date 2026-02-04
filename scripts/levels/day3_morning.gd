extends Node2D

@onready var dialog_control = $CanvasLayer/DialogueControl
@onready var level_manager = $LevelManager
@onready var player = $Player
@onready var spawn_point = $Kasur/Marker2D
@onready var door_trigger = $DoorTrigger

var dialog_finished_first: bool = false
var dialog_finished_second: bool = false
var tasks_completed: bool = false
var door_triggered: bool = false

const DIALOG_WAKE_UP = "res://dialogue-data/data-ready/Dialogue - Day 3 Wake Up.json"
const DIALOG_CALL_FRIEND = "res://dialogue-data/data-ready/Dialogue - Day 3 Call Friend.json"
const DIALOG_FRIEND_ARRIVE = "res://dialogue-data/data-ready/Dialogue - Day 3 Friend Arrive.json"

func _ready():
	if spawn_point:
		player.global_position = spawn_point.global_position

	# Disable player movement saat dialog
	player.set_physics_process(false)

	# Connect signals
	dialog_control.dialog_finished.connect(_on_dialog_finished)
	level_manager.all_tasks_completed.connect(_on_tasks_completed)

	# Connect door trigger
	if door_trigger:
		door_trigger.body_entered.connect(_on_door_entered)

	await get_tree().process_frame

	# Start opening dialog - Serra bangun frustrasi
	print("🌅 Day 3 Morning - Serra bangun dan frustrasi")
	dialog_control.play_dialog(DIALOG_WAKE_UP)

func _on_dialog_finished():
	if not dialog_finished_first:
		# Dialog pertama selesai - Serra memutuskan untuk keluar mencari bantuan
		dialog_finished_first = true
		print("📢 Serra keluar untuk ajak teman...")

		# Auto trigger door (Serra keluar)
		_trigger_go_out()

	elif not dialog_finished_second:
		# Dialog kedua selesai - teman sudah datang
		dialog_finished_second = true
		print("👫 Teman sudah datang! Mulai gameplay beberes bareng")
		player.set_physics_process(true)

func _trigger_go_out():
	# Serra keluar untuk ajak teman
	print("🚪 Serra keluar rumah...")

	# Transisi dengan teks "Beberapa Saat Kemudian"
	# TODO: Buat transisi custom dengan text overlay

	await get_tree().create_timer(2.0).timeout

	# Serra datang bersama temannya (Tarri)
	print("👫 Serra dan Tarri kembali")
	dialog_control.play_dialog(DIALOG_FRIEND_ARRIVE)

func _on_tasks_completed():
	tasks_completed = true
	print("✅ Tasks Day 3 selesai! Beberes bareng teman berhasil")

	# Disable player sementara untuk dialog
	player.set_physics_process(false)

	# Play dialog sebelum tidur bareng
	# Dialog: "Udah malam, tidur yuk"
	dialog_control.play_dialog(DIALOG_CALL_FRIEND)

	# Re-enable player setelah dialog selesai
	await dialog_control.dialog_finished
	player.set_physics_process(true)

	print("😴 Sekarang bisa tidur bareng di kasur")

func _on_door_entered(body):
	if body is Player and tasks_completed and not door_triggered:
		door_triggered = true
		print("😴 Tidur bareng teman - Transisi ke Day 4 Boss")

		# Disable player movement
		player.set_physics_process(false)

		# Transisi ke Day 4 Boss Fight (saat tidur, teman nangkep alter ego)
		DayManager.next_scene()
