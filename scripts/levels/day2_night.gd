extends Node2D

@onready var dialog_control = $CanvasLayer/DialogueControl
@onready var level_manager = $LevelManager
@onready var player = $Player
@onready var spawn_point = $Marker2D
@onready var wardrobe = $Wardrobe
@onready var bed = $Bed

@export var player_sprite_start: Texture2D

var dialog_finished_first: bool = false
var choice_made: bool = false
var chose_option_1: bool = false
var tasks_completed: bool = false

const DIALOG_BACK_HOME = "res://dialogue-data/data-ready/Dialogue - Day 2 Back Home.json"

func _ready():
	if player_sprite_start:
		set_player_sprite(player_sprite_start)

	if spawn_point:
		player.global_position = spawn_point.global_position

	player.set_physics_process(false)

	dialog_control.dialog_finished.connect(_on_dialog_finished)
	dialog_control.choice_selected.connect(_on_choice_selected)
	level_manager.all_tasks_completed.connect(_on_tasks_completed)

	if wardrobe:
		wardrobe.wardrobe_completed.connect(_on_wardrobe_completed)
	if bed:
		bed.sleep_started.connect(_on_bed_sleep)

	await get_tree().process_frame

	print("Day 2 Night - Starting dialog")
	dialog_control.play_dialog(DIALOG_BACK_HOME)

func _on_dialog_finished():
	if not dialog_finished_first:
		dialog_finished_first = true
		print("Dialog selesai, mulai gameplay")
		player.set_physics_process(true)

func _on_tasks_completed():
	tasks_completed = true
	print("Tasks selesai, ganti baju di wardrobe")

func _on_wardrobe_completed():
	print("Ganti baju selesai")

	player.set_physics_process(true)

func _on_choice_selected(choice_id: String):
	choice_made = true
	print("Player memilih: ", choice_id)

	if choice_id == "pilih_1" or choice_id == "1":
		chose_option_1 = true
		print("Pilihan 1: Coba begadang, tetap harus beberes dulu")

		player.set_physics_process(true)

		print("Sekarang harus selesaikan tasks lagi sebelum tidur")

	elif choice_id == "pilih_2" or choice_id == "2":
		chose_option_1 = false
		print("Pilihan 2: Bodo amat, langsung tidur - bad ending")

		if bed:
			bed.enable_direct_sleep()

		player.set_physics_process(true)

		print("Bed sekarang bisa dipakai langsung untuk bad ending")

func _on_bed_sleep():
	print("Player tidur")
	player.set_physics_process(false)

	if chose_option_1:
		print("Transisi ke Day 3 Boss")
		DayManager.next_scene()
	else:
		print("Transisi ke Bad Ending")
		DayManager.bad_ending()

func set_player_sprite(texture: Texture2D):
	if not texture:
		return

	var player_sprite = player.get_node_or_null("Sprite2D")
	if player_sprite:
		player_sprite.texture = texture
		print("Player sprite set to: ", texture.resource_path)
