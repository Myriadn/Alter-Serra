extends Node2D

var image : Texture2D
var obj_name : String = ""

@onready var texture_rect: TextureRect = $Control/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_rect.texture = image

func _clear_holder():
	queue_free()
