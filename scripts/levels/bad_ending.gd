extends Node2D

var canvas_layer: CanvasLayer
var background: ColorRect
var title_label: Label
var desc_label: Label

func _ready():
	_setup_ui()
	await get_tree().process_frame
	_show_bad_ending()

func _setup_ui():
	canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100
	add_child(canvas_layer)

	background = ColorRect.new()
	background.color = Color(0, 0, 0, 1)
	background.anchor_right = 1.0
	background.anchor_bottom = 1.0
	canvas_layer.add_child(background)

	var center_container = CenterContainer.new()
	center_container.anchor_right = 1.0
	center_container.anchor_bottom = 1.0
	canvas_layer.add_child(center_container)

	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	center_container.add_child(vbox)

	title_label = Label.new()
	title_label.text = "BAD ENDING"
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 64)
	title_label.add_theme_color_override("font_color", Color(1, 0, 0, 1))
	title_label.modulate.a = 0
	vbox.add_child(title_label)

	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 50)
	vbox.add_child(spacer)

	desc_label = Label.new()
	desc_label.text = "Serra memilih untuk tidak peduli.\nKamarnya akan berantakan selamanya..."
	desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	desc_label.add_theme_font_size_override("font_size", 24)
	desc_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	desc_label.modulate.a = 0
	vbox.add_child(desc_label)

func _show_bad_ending():
	print("BAD ENDING - Player memilih untuk tidak peduli")

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(title_label, "modulate:a", 1.0, 1.0)
	tween.tween_property(desc_label, "modulate:a", 1.0, 1.5).set_delay(0.5)

	await tween.finished
	await get_tree().create_timer(3.0).timeout

	_return_to_menu()

func _return_to_menu():
	print("Kembali ke main menu")
	await SceneManager._change_scene("res://scenes/main menu/Main Menu.tscn")
