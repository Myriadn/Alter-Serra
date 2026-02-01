extends AudioStreamPlayer2D

@onready var audio: AudioStreamPlayer2D = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio.play()
	await audio.finished
	queue_free()
