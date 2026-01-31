extends Node2D

var image : Texture2D
var obj_name : String = ""

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite.texture = image

	if image:
		# Hitung scale yang proporsional berdasarkan max size
		var tex_size = image.get_size()
		var max_size = 24.0  # Max pixel size untuk held item

		# Scale proporsional (keep aspect ratio)
		var scale_factor = 1.0
		if tex_size.x > tex_size.y:
			scale_factor = max_size / tex_size.x
		else:
			scale_factor = max_size / tex_size.y

		sprite.scale = Vector2(scale_factor, scale_factor)  # Sama X dan Y = tidak stretch

func _clear_holder():
	queue_free()
