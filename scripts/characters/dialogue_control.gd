extends Control

signal end_1
signal end_2

@export var dialog_json_path: String = ""
@export var start_id: String = "start"
@export var type_speed: float = 0.03

var dialog_data: Dictionary = {}
var current_id: String = ""

var is_typing: bool = false
var can_continue: bool = false

@onready var name_label: Label = $anchor/player_name
@onready var dialog_label: Label = $anchor/dialogue
@onready var portrait: TextureRect = $potrait
@onready var choices_container: HBoxContainer = $anchor/ChoicesContainer


# =========================
# READY
# =========================
func _ready():
	load_dialog()
	start_dialog()


# =========================
# LOAD JSON
# =========================
func load_dialog():
	var file := FileAccess.open(dialog_json_path, FileAccess.READ)
	if file == null:
		push_error("Dialog JSON tidak ditemukan!")
		return

	dialog_data = JSON.parse_string(file.get_as_text())
	file.close()


# =========================
# START
# =========================
func start_dialog():
	current_id = start_id
	visible = true
	show_dialog()


# =========================
# SHOW DIALOG
# =========================
func show_dialog():
	if not dialog_data.has(current_id):
		push_error("Dialog ID tidak ditemukan: " + current_id)
		end_dialog(0)
		return

	var node: Dictionary = dialog_data[current_id]

	# reset state
	is_typing = false
	can_continue = false
	clear_choices()

	# ---- Nama & teks ----
	name_label.text = node.get("speaker", "")
	dialog_label.text = node.get("text", "")
	dialog_label.visible_characters = 0

	# ---- Portrait ----
	if node.has("image") and node["image"] != "":
		var tex = load(node["image"])
		if tex:
			portrait.texture = tex
			portrait.visible = true
		else:
			portrait.visible = false
	else:
		portrait.visible = false

	# mulai typewriter
	type_text(node)


# =========================
# TYPEWRITER
# =========================
func type_text(node: Dictionary):
	is_typing = true
	can_continue = false

	var total := dialog_label.text.length()

	for i in range(total):
		if not is_typing:
			break

		dialog_label.visible_characters += 1
		await get_tree().create_timer(type_speed).timeout

	# selesai ngetik
	is_typing = false
	can_continue = true

	# kalau ada choice → tampilkan
	if node.has("choices") and node["choices"].size() > 0:
		show_choices(node["choices"])


# =========================
# INPUT (LMB)
# =========================
func _input(event):
	if not visible:
		return

	if Input.is_action_just_pressed("lmb"):
		on_click_continue()

func on_click_continue():
	# kalau lagi ngetik → skip animasi
	if is_typing:
		is_typing = false
		dialog_label.visible_characters = dialog_label.text.length()
		can_continue = true
		return

	# kalau belum boleh lanjut → ignore
	if not can_continue:
		return

	var node: Dictionary = dialog_data[current_id]

	# kalau ada choice → tunggu player milih
	if node.has("choices") and node["choices"].size() > 0:
		return

	# lanjut ke next
	if node.has("next"):
		if node["next"] == "end_1":
			end_dialog(0)
		elif node["next"] == "end_2":
			end_dialog(1)
		else :
			current_id = node["next"]
			show_dialog()
	else:
		end_dialog(0)


# =========================
# CHOICES
# =========================
func show_choices(choices: Array):
	for choice in choices:
		var inst = preload("res://scenes/main menu/basebutton.tscn").instantiate()
		inst._text = choice.get("text", "")
		inst.next_id = choice.get("next", "")
		inst.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		inst._direction = 3
		inst.power = 0.4

		inst.button_press.connect(_on_choice_pressed)

		choices_container.add_child(inst)


func _on_choice_pressed(btn):
	current_id = btn.get_parent().next_id
	show_dialog()


func clear_choices():
	for child in choices_container.get_children():
		child.queue_free()


# =========================
# END
# =========================
func end_dialog(state : int):
	visible = false
	if state == 0 :
		emit_signal("end_1")
		print("cannon ending")
	elif state == 1 :
		print("true ending")
	print("Dialog selesai")
