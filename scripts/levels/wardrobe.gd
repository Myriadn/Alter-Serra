extends StaticBody2D
class_name Wardrobe

signal task_completed

@export var furniture_name: String = "Lemari"
@export var change_duration: float = 2.0
@export var player_sprite_after: Texture2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer
@onready var hint = $InteractionHint if has_node("InteractionHint") else null

var is_completed: bool = false
var is_changing: bool = false
var player_ref: Player = null
var progress_bar = null
var elapsed_time: float = 0.0

func _ready():
	add_to_group("interactables")

	# Hide hint by default
	if hint:
		hint.hide_hint()

	# Setup timer
	if timer:
		timer.one_shot = true
		timer.wait_time = change_duration
		timer.timeout.connect(_on_timer_timeout)

func can_be_interacted() -> bool:
	return not is_completed and not is_changing

func interact():
	if not can_be_interacted():
		print("❌ Sudah ganti baju atau sedang ganti baju")
		return false

	# Get player reference
	player_ref = get_tree().get_first_node_in_group("Player")
	if not player_ref:
		push_error("Player not found!")
		return false

	print("👕 Mulai ganti baju...")

	# Hide hint when interacting
	if hint:
		hint.hide_hint()

	# Start changing
	is_changing = true
	elapsed_time = 0.0

	# Disable player movement
	player_ref.set_physics_process(false)

	# Show progress bar
	if player_ref.has_node("CleansingProgress"):
		progress_bar = player_ref.get_node("CleansingProgress")
		progress_bar.max_value = change_duration
		progress_bar.value = 0
		progress_bar.show()

	# Start timer
	timer.start()

	return true

func _process(delta):
	# Update progress bar while changing
	if is_changing and progress_bar:
		elapsed_time += delta
		progress_bar.value = elapsed_time

func _on_timer_timeout():
	print("✅ Selesai ganti baju!")

	is_changing = false
	is_completed = true

	# Change player sprite
	change_player_sprite()

	# Hide progress bar
	if progress_bar:
		progress_bar.hide()
		progress_bar = null

	# Enable player movement
	if player_ref:
		player_ref.set_physics_process(true)

	# Emit task completed
	task_completed.emit()

# Show/hide hint when player near
func _on_area_2d_body_entered(body):
	if body is Player and can_be_interacted():
		if hint:
			hint.show_hint()

func _on_area_2d_body_exited(body):
	if body is Player:
		if hint:
			hint.hide_hint()

func change_player_sprite():
	if not player_ref:
		return

	var player_sprite = player_ref.get_node_or_null("Sprite2D")

	if player_sprite and player_sprite_after:
		player_sprite.texture = player_sprite_after
		print("✅ Player sprite changed!")
	else:
		push_warning("Player sprite atau texture not configured")
