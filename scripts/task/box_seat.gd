extends StaticBody2D

@onready var seat: Sprite2D = $seat
@onready var hover: Sprite2D = $hover

@export var is_placed = false

const SEAT = preload("uid://mgaikogv36xx")
const BOX = preload("uid://5jwrcqoqsm4i")

func _ready() -> void:
	set_item(is_placed)
	hover.hide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !is_placed:
		hover.show()
	body.available_drop_place = self

func _on_area_2d_body_exited(body: Node2D) -> void:
	if !is_placed:
		hover.hide()
	body.available_drop_place = null

func set_item(state : bool):
	if state :
		seat.texture = BOX
	else:
		seat.texture = SEAT
	is_placed = state
	hover.hide()
