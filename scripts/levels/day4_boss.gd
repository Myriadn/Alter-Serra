extends Node2D

@onready var dialog_control = $CanvasLayer/DialogueControl
@onready var boss_manager = $BossManager  # Custom manager untuk boss fight
@onready var player = $AlterEgo  # Alter ego character
@onready var friend = $Tarri  # Tarri (friend)
@onready var spawn_point = $Marker2D

var dialog_finished: bool = false
var boss_mission_complete: bool = false

const DIALOG_BOSS_INTRO = "res://dialogue-data/data-ready/Dialogue - Day 4 Boss Intro.json"
const DIALOG_CAUGHT = "res://dialogue-data/data-ready/Dialogue - Day 4 Caught.json"

func _ready():
	if spawn_point and player:
		player.global_position = spawn_point.global_position

	# Disable player movement saat dialog
	if player:
		player.set_physics_process(false)

	# Connect signals
	if dialog_control:
		dialog_control.dialog_finished.connect(_on_dialog_finished)

	# Connect boss manager signals
	if boss_manager:
		boss_manager.mission_complete.connect(_on_mission_complete)
		boss_manager.player_caught.connect(_on_player_caught)

	await get_tree().process_frame

	# Start boss intro dialog (alter ego muncul)
	print("👹 Day 4 Boss - Alter Ego vs Tarri (Tag Game)")
	if dialog_control:
		dialog_control.play_dialog(DIALOG_BOSS_INTRO)
	else:
		# Langsung mulai fight kalau gak ada dialog
		_start_boss_fight()

func _on_dialog_finished():
	if not dialog_finished:
		dialog_finished = true
		_start_boss_fight()
	elif boss_mission_complete:
		# Dialog setelah tertangkap selesai - reveal alter ego
		print("🎭 Alter ego revealed! Transisi ke Day 4 Ending")
		_transition_to_ending()

func _start_boss_fight():
	print("⚔️ Tag game dimulai!")
	print("🎯 Mission: Berantakin semua barang sambil hindari Tarri")

	if player:
		player.set_physics_process(true)

	# Aktivasi boss AI/behavior (Tarri mencoba nangkep)
	if boss_manager:
		boss_manager.start_fight()

	# Aktivasi friend AI (Tarri patrol/chase)
	if friend:
		friend.start_chase()

func _on_mission_complete():
	print("🎉 Misi berantakin selesai!")

	# Setelah misi selesai, alter ego otomatis tertangkap
	_on_player_caught()

func _on_player_caught():
	boss_mission_complete = true
	print("🤝 Alter ego tertangkap oleh Tarri!")

	# Disable player movement
	if player:
		player.set_physics_process(false)

	# Stop friend AI
	if friend:
		friend.stop_chase()

	# Play dialog caught & reveal
	if dialog_control:
		dialog_control.play_dialog(DIALOG_CAUGHT)
	else:
		# Langsung transisi kalau gak ada dialog
		_transition_to_ending()

func _transition_to_ending():
	# Transisi ke Day 4 Ending (Serra bangun, Tarri kasih bukti)
	DayManager.next_scene()
