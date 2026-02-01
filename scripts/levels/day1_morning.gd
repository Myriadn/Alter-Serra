extends Node2D

@onready var dialog_control = $CanvasLayer/DialogueControl
@onready var level_manager = $LevelManager
@onready var player = $Player
@onready var spawn_point = $Kasur/Marker2D
@onready var door_trigger = $DoorTrigger

var dialog_finished_first: bool = false
var tasks_completed: bool = false
var door_triggered: bool = false

const DIALOG_WAKE_UP = "res://dialogue-data/data-ready/Dialogue - Day 1 Wake Up.json"
const DIALOG_GO_WORK = "res://dialogue-data/data-ready/Dialogue - Day 1 Go Work.json"

func _ready():
	player.global_position = spawn_point.global_position

	# Disable player movement saat dialog
	player.set_physics_process(false)

	# Connect signals
	dialog_control.dialog_finished.connect(_on_dialog_finished)
	level_manager.all_tasks_completed.connect(_on_tasks_completed)

	# Connect door trigger
	if door_trigger:
		door_trigger.body_entered.connect(_on_door_entered)

	await Fade.fade_in(1.0)
	# Start opening dialog
	dialog_control.play_dialog(DIALOG_WAKE_UP)

func _on_dialog_finished():
	if not dialog_finished_first:
		# Dialog pertama selesai → mulai gameplay
		dialog_finished_first = true
		print("📢 Dialog selesai, mulai gameplay!")
		player.set_physics_process(true)

func _on_tasks_completed():
	tasks_completed = true
	# Play dialog pintu
	dialog_control.play_dialog(DIALOG_GO_WORK)

func _on_door_entered(body):
	if body is Player and tasks_completed and not door_triggered:
		door_triggered = true
		# Disable player movement
		player.set_physics_process(false)
		await Fade.fade_out(1.0)
		DayManager.next_scene()
