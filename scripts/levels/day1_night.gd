extends Node2D

@onready var dialog_control = $CanvasLayer/DialogueControl
@onready var level_manager = $LevelManager
@onready var player = $Player
@onready var spawn_point = $Marker2D
@onready var wardrobe = $Wardrobe  # Reference ke wardrobe

@export var player_sprite_start: Texture2D  # Player sprite awal (baju kerja)

var dialog_finished_first: bool = false

func _ready():
	print("🌙 DAY1_NIGHT - _ready() called")

	# Set player sprite awal (baju kerja/piyama awal)
	set_player_sprite(player_sprite_start)

	if spawn_point:
		player.global_position = spawn_point.global_position

	player.set_physics_process(false)

	# Connect signals
	dialog_control.dialog_finished.connect(_on_dialog_finished)
	level_manager.all_tasks_completed.connect(_on_tasks_completed)

	# Connect wardrobe
	if wardrobe:
		wardrobe.task_completed.connect(_on_wardrobe_completed)

	await get_tree().process_frame

	# Fade in
	await Fade.fade_in(0.5)

	# Start dialog
	dialog_control.play_dialog("res://dialogue-data/data-ready/Dialogue - Day 1 Back Home.json")

func _on_dialog_finished():
	if not dialog_finished_first:
		dialog_finished_first = true
		print("📢 Mulai gameplay malam!")
		player.set_physics_process(true)

func _on_wardrobe_completed():
	print("✅ Ganti baju selesai! Task +1")

func _on_tasks_completed():
	print("✅ Semua task selesai! Bisa tidur di kasur.")

func set_player_sprite(texture: Texture2D):
	if not texture:
		return

	var player_sprite = player.get_node_or_null("Sprite2D")
	if player_sprite:
		player_sprite.texture = texture
		print("👕 Player sprite set to: ", texture.resource_path)
