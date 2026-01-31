@tool
extends Control

signal button_press(button_node)

@onready var button: Button = $button

@export var _text : String :
	set(val):
		_text = val
		if Engine.is_editor_hint() and is_inside_tree():
			update_preview()
	get:
		return _text

@export_enum("Kiri", "Kanan", "Atas", "Bawah")
var _direction : int = 0 :
	set(val):
		_direction = val
		if Engine.is_editor_hint() and is_inside_tree():
			update_preview()
	get:
		return _direction

@export var durasi : float = 0.5
@export var power : float = 0.5
var dir : Vector2
var next_id = ""

func update_preview():
	button.text = _text
	if _direction == 0:
		dir = Vector2.LEFT
	elif _direction == 1:
		dir = Vector2.RIGHT
	elif _direction == 2 :
		dir = Vector2.UP
	else :
		dir = Vector2.DOWN
	
func _ready() -> void:
	update_preview()

func _on_mouse_entered() -> void:
	GlobalHandle._make_tween(button, "position", dir * power * 10, durasi)

func _on_mouse_exited() -> void:
	GlobalHandle._make_tween(button, "position", Vector2.ZERO, durasi)


func _on_button_button_up() -> void:
	emit_signal("button_press", button)
