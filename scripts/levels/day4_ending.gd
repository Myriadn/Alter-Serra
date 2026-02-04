extends Node2D

@onready var dialog_control = $CanvasLayer/DialogueControl
@onready var player = $Player
@onready var friend = $Tarri
@onready var spawn_point = $Kasur/Marker2D

var dialog_finished_first: bool = false
var dialog_finished_second: bool = false
var ending_triggered: bool = false

const DIALOG_WAKE_UP = "res://dialogue-data/data-ready/Dialogue - Day 4 Wake Up.json"
const DIALOG_REVEAL = "res://dialogue-data/data-ready/Dialogue - Day 4 Reveal.json"
const DIALOG_END = "res://dialogue-data/data-ready/Dialogue - Day 4 End.json"

func _ready():
	if spawn_point and player:
		player.global_position = spawn_point.global_position

	# Disable player movement saat dialog
	if player:
		player.set_physics_process(false)

	# Connect signals
	if dialog_control:
		dialog_control.dialog_finished.connect(_on_dialog_finished)

	await get_tree().process_frame

	# Start ending dialog - Serra dibangunkan oleh Tarri
	print("🌅 Day 4 Ending - Serra bangun, Tarri kasih bukti")
	if dialog_control:
		dialog_control.play_dialog(DIALOG_WAKE_UP)
	else:
		_show_ending()

func _on_dialog_finished():
	if not dialog_finished_first:
		# Dialog pertama selesai - Tarri bilang udah ketemu pelakunya
		dialog_finished_first = true
		print("🔍 Tarri: Udah ketemu pelakunya!")

		# Play dialog reveal (Tarri tunjukkan bukti foto alter ego)
		if dialog_control:
			dialog_control.play_dialog(DIALOG_REVEAL)
		else:
			_show_ending()

	elif not dialog_finished_second:
		# Dialog reveal selesai - Serra kaget
		dialog_finished_second = true
		print("😱 Serra: Lah, seriusan? Aku sendiri?")

		# Play dialog ending (wrap up cerita)
		if dialog_control:
			dialog_control.play_dialog(DIALOG_END)
		else:
			_show_ending()

	elif not ending_triggered:
		# Semua dialog selesai - TAMAT
		ending_triggered = true
		_show_ending()

func _show_ending():
	print("🎬 TAMAT - Game selesai!")

	# Wait a moment
	await get_tree().create_timer(2.0).timeout

	# Transition to credits or main menu
	# Option 1: Show credits scene
	# await SceneManager._change_scene("res://scenes/credits.tscn")

	# Option 2: Back to main menu
	await SceneManager._change_scene("res://scenes/main menu/Main Menu.tscn")

	print("🎉 Terima kasih sudah bermain!")
