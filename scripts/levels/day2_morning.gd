extends Node2D

@onready var dialog_control = $CanvasLayer/DialogueControl
@onready var level_manager = $LevelManager
@onready var player = $Player
@onready var spawn_point = $Kasur/Marker2D
@onready var door_trigger = $DoorTrigger

var dialog_step: int = 0
var tasks_completed: bool = false
var door_triggered: bool = false

const DIALOG_WAKE_UP_1 = "res://dialogue-data/data-ready/Dialogue - Day 2 Wake Up 1.json"
const DIALOG_WAKE_UP_2 = "res://dialogue-data/data-ready/Dialogue - Day 2 Wake Up 2.json"
const DIALOG_GO_WORK = "res://dialogue-data/data-ready/Dialogue - Day 2 Go Work.json"

func _ready():
	if spawn_point:
		player.global_position = spawn_point.global_position

	player.set_physics_process(false)

	dialog_control.dialog_finished.connect(_on_dialog_finished)
	level_manager.all_tasks_completed.connect(_on_tasks_completed)

	if door_trigger:
		door_trigger.body_entered.connect(_on_door_entered)

	await get_tree().process_frame

	print("Day 2 Morning - Starting dialog 1")
	dialog_control.play_dialog(DIALOG_WAKE_UP_1)

func _on_dialog_finished():
	if dialog_step == 0:
		dialog_step = 1
		print("Dialog 1 selesai, mulai dialog 2")
		dialog_control.play_dialog(DIALOG_WAKE_UP_2)

	elif dialog_step == 1:
		dialog_step = 2
		print("Dialog 2 selesai, mulai gameplay")
		player.set_physics_process(true)

	elif dialog_step == 2 and tasks_completed:
		dialog_step = 3
		print("Dialog go work selesai")

func _on_tasks_completed():
	tasks_completed = true
	print("Tasks Day 2 selesai")

	player.set_physics_process(false)
	dialog_control.play_dialog(DIALOG_GO_WORK)

	await dialog_control.dialog_finished
	player.set_physics_process(true)

func _on_door_entered(body):
	if body is Player and tasks_completed and not door_triggered:
		door_triggered = true
		print("Pergi kerja - Transisi ke Day 2 Night")

		player.set_physics_process(false)
		DayManager.next_scene()
