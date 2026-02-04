extends StaticBody2D
class_name InteractiveFurniture

signal interacted(furniture: InteractiveFurniture)
signal task_completed(furniture: InteractiveFurniture)

@export var furniture_name: String = "Furniture"
@export var can_interact: bool = true
@export var complete_task_on_interact: bool = true  # Auto +1 task pas interact
@export var show_hover_hint: bool = true

# Optional: Texture changes
@export var sprite_before: Texture2D
@export var sprite_after: Texture2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var hover_hint: Sprite2D = $HoverHint  # Optional visual hint

var is_completed: bool = false

func _ready():
	add_to_group("interactables")

	if sprite and sprite_before:
		sprite.texture = sprite_before

	if hover_hint:
		hover_hint.hide()

func can_be_interacted() -> bool:
	return can_interact and not is_completed

func interact():
	if not can_be_interacted():
		return

	print("🛋️ Interacted with: ", furniture_name)

	# Change texture if configured
	if sprite and sprite_after:
		sprite.texture = sprite_after

	# Mark completed
	is_completed = true
	can_interact = false

	# Emit signals
	interacted.emit(self)

	if complete_task_on_interact:
		task_completed.emit(self)

	return true
