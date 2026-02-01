extends Node2D

@onready var dialog_control = $CanvasLayer/DialogueControl
@onready var level_manager = $LevelManager
@onready var player = $Player
@onready var spawn_point = $Marker2D
@onready var wardrobe = $Wardrobe  # Reference ke wardrobe
@onready var bed = $Bed  # Reference ke bed

@export var player_sprite_start: Texture2D

var dialog_finished_first: bool = false

func _ready():
	# Set player sprite awal (baju kerja/piyama awal)
	set_player_sprite(player_sprite_start)

	if spawn_point:
		player.global_position = spawn_point.global_position

	player.set_physics_process(false)

	# Connect signals
	dialog_control.dialog_finished.connect(_on_dialog_finished)
	level_manager.all_tasks_completed.connect(_on_tasks_completed)

	# Connect wardrobe dan bed signals
	if wardrobe:
		wardrobe.wardrobe_completed.connect(_on_wardrobe_completed)
	if bed:
		bed.sleep_started.connect(_on_bed_sleep)

	await get_tree().process_frame

	# Start dialog tanpa fade dulu (biar cepet test)
	print("🎭 Starting dialog...")
	dialog_control.play_dialog("res://dialogue-data/data-ready/Dialogue - Day 1 Back Home.json")

func _on_dialog_finished():
	if not dialog_finished_first:
		dialog_finished_first = true
		print("📢 Dialog selesai, player bisa bergerak!")
		player.set_physics_process(true)

func _on_tasks_completed():
	print("✅ Semua task selesai! Sekarang bisa ganti baju di lemari.")

func _on_wardrobe_completed():
	print("👕 Ganti baju selesai! Sekarang bisa tidur di kasur.")

func _on_bed_sleep():
	print("😴 Player tidur... Transisi ke Day 2 Morning")
	player.set_physics_process(false)

	# Gunakan DayManager yang udah pakai SceneManager
	if DayManager:
		DayManager.next_scene()
	else:
		# Fallback jika DayManager tidak ada
		print("⚠️ DayManager not found! Using direct scene change")
		await SceneManager._change_scene_w_day_count("res://scenes/levels/master/day2/day2_morning.tscn", 2)

func set_player_sprite(texture: Texture2D):
	if not texture:
		return

	var player_sprite = player.get_node_or_null("Sprite2D")
	if player_sprite:
		player_sprite.texture = texture
		print("👕 Player sprite set to: ", texture.resource_path)
