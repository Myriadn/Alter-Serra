extends Node2D

@onready var canvas_layer = $CanvasLayer
@onready var dialog_control = $CanvasLayer/DialogueControl if has_node("CanvasLayer/DialogueControl") else null
@onready var level_manager = $LevelManager if has_node("LevelManager") else null
@onready var player = $Player if has_node("Player") else null

var cutscene_ui: CanvasLayer
var mask_sprite: Sprite2D
var title_label: Label
var game_ended: bool = false

const MASK_TEXTURE_PATH = "res://asset/alterEgo/topeng.png"

func _ready():
	if player:
		player.set_physics_process(false)

	if level_manager:
		level_manager.all_tasks_completed.connect(_on_all_tasks_completed)

	_connect_ai_collision()

	await get_tree().process_frame

	print("Day 3 Boss - Gameplay dimulai")
	await get_tree().create_timer(1.0).timeout

	if player:
		player.set_physics_process(true)

func _connect_ai_collision():
	var ai_nodes = get_tree().get_nodes_in_group("enemies")

	if ai_nodes.is_empty():
		ai_nodes = []
		for child in get_children():
			if child.name.begins_with("AIHorizontal") or child.name.begins_with("AIVertical"):
				ai_nodes.append(child)

	for ai in ai_nodes:
		if ai is Area2D:
			if not ai.body_entered.is_connected(_on_ai_body_entered):
				ai.body_entered.connect(_on_ai_body_entered)
				print("Connected AI collision: ", ai.name)

func _on_ai_body_entered(body):
	if not game_ended and body.is_in_group("Player"):
		print("AI caught player!")
		_on_player_caught()

func _on_player_caught():
	if game_ended:
		return

	game_ended = true
	print("Player kena AI! Game Over")

	if player:
		player.set_physics_process(false)

	_show_to_be_continued()

func _on_all_tasks_completed():
	if game_ended:
		return

	game_ended = true
	print("Semua tasks selesai! To Be Continued")

	if player:
		player.set_physics_process(false)

	_show_to_be_continued()

func _show_to_be_continued():
	_setup_cutscene()
	await get_tree().process_frame
	_play_cutscene()

func _setup_cutscene():
	cutscene_ui = CanvasLayer.new()
	cutscene_ui.layer = 99
	add_child(cutscene_ui)

	var background = ColorRect.new()
	background.color = Color(0, 0, 0, 0.8)
	background.anchor_right = 1.0
	background.anchor_bottom = 1.0
	cutscene_ui.add_child(background)

	var center = CenterContainer.new()
	center.anchor_right = 1.0
	center.anchor_bottom = 1.0
	cutscene_ui.add_child(center)

	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_child(vbox)

	mask_sprite = Sprite2D.new()
	if ResourceLoader.exists(MASK_TEXTURE_PATH):
		mask_sprite.texture = load(MASK_TEXTURE_PATH)
	mask_sprite.scale = Vector2(0.5, 0.5)
	mask_sprite.modulate.a = 0

	var texture_container = Control.new()
	texture_container.custom_minimum_size = Vector2(200, 200)
	vbox.add_child(texture_container)
	texture_container.add_child(mask_sprite)
	mask_sprite.position = texture_container.custom_minimum_size / 2

	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 30)
	vbox.add_child(spacer)

	title_label = Label.new()
	title_label.text = "TO BE CONTINUED..."
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 48)
	title_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	title_label.modulate.a = 0
	vbox.add_child(title_label)

func _play_cutscene():
	print("Menampilkan cutscene To Be Continued")

	await get_tree().create_timer(0.5).timeout

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(mask_sprite, "modulate:a", 1.0, 1.5)
	tween.tween_property(title_label, "modulate:a", 1.0, 1.5).set_delay(0.5)

	await tween.finished
	await get_tree().create_timer(3.0).timeout

	_end_cutscene()

func _end_cutscene():
	print("Cutscene selesai - Transisi ke Day 3 Morning")
	DayManager.next_scene()
