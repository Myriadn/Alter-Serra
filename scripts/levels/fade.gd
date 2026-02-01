extends CanvasLayer

@onready var anim: AnimationPlayer = $ColorRect/AnimationPlayer
@onready var color_rect: ColorRect = $ColorRect

signal fade_finished

func _ready():
	# Start transparent (optional, tergantung kebutuhan)
	color_rect.modulate.a = 0.0

func fade_in(duration: float = 0.5):
	"""Fade from black to transparent"""
	anim.speed_scale = 0.5 / duration  # Adjust speed
	anim.play("fade_in")
	await anim.animation_finished
	fade_finished.emit()

func fade_out(duration: float = 0.5):
	"""Fade from transparent to black"""
	anim.speed_scale = 0.5 / duration
	anim.play("fade_out")
	await anim.animation_finished
	fade_finished.emit()
