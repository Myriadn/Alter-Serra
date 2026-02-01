extends Node2D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label
@onready var background: ColorRect = $Background

@export var hint_text: String = "E"
@export var offset_y: float = -30.0

var is_visible: bool = false

func _ready():
	# Set initial position
	position.y = offset_y

	# Update text if configured
	if label:
		label.text = hint_text

	# Start hidden
	modulate.a = 0.0
	visible = false

func show_hint():
	if is_visible:
		return

	is_visible = true
	visible = true

	if anim:
		anim.play("fade_in")
		await anim.animation_finished
		anim.play("float")

func hide_hint():
	if not is_visible:
		return

	is_visible = false

	if anim:
		anim.stop()
		anim.play("fade_out")
		await anim.animation_finished

	visible = false

func set_hint_text(text: String):
	hint_text = text
	if label:
		label.text = text

func _process(_delta):
	# Always face camera (no rotation from parent)
	global_rotation = 0
