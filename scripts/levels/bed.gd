extends InteractiveFurniture
class_name Bed

@export var require_wardrobe_done: bool = true

signal sleep_started

var wardrobe: Wardrobe = null
var wardrobe_done: bool = false
var allow_direct_sleep: bool = false
@onready var hint = $InteractionHint if has_node("InteractionHint") else null

func _ready():
	super._ready()

	if hint:
		hint.hide_hint()

	await get_tree().process_frame

	var scene_root = get_tree().current_scene
	if scene_root:
		wardrobe = scene_root.get_node_or_null("Wardrobe")
		if wardrobe:
			wardrobe.wardrobe_completed.connect(_on_wardrobe_completed)

func _on_wardrobe_completed():
	wardrobe_done = true
	print("Bed: Wardrobe completed, bed now available")

func enable_direct_sleep():
	allow_direct_sleep = true
	print("Bed: Direct sleep enabled")

func can_be_interacted() -> bool:
	if not super.can_be_interacted():
		return false

	if allow_direct_sleep:
		return true

	if require_wardrobe_done and not wardrobe_done:
		return false

	return true

func interact():
	if not can_be_interacted():
		return false

	print("Bed: Sleep interaction")

	if hint:
		hint.hide_hint()

	super.interact()
	sleep_started.emit()

	return true

func _on_area_2d_body_entered(body):
	if body is Player:
		if can_be_interacted() and hint:
			hint.show_hint()

func _on_area_2d_body_exited(body):
	if body is Player:
		if hint:
			hint.hide_hint()
