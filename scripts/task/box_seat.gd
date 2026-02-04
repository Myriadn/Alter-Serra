extends StaticBody2D
class_name BoxSeat

@onready var seat: Sprite2D = $seat
@onready var hover: Sprite2D = $hover

@export var is_placed = false
@export var accepted_item_type: String = "BOX"

const SEAT = preload("uid://mgaikogv36xx")

signal item_placed_correctly(box_seat: BoxSeat)
signal player_entered_zone
signal player_exited_zone

func _ready() -> void:
	set_item(is_placed, null)  # Pass null untuk init
	hover.hide()
	add_to_group("box_seats")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if not is_placed:
			hover.show()
			player_entered_zone.emit()
		body.available_drop_place = self

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		if not is_placed:
			hover.hide()
			player_exited_zone.emit()
		body.available_drop_place = null

func can_place_item(item_name: String) -> bool:
	if is_placed:
		return false
	return item_name == accepted_item_type or accepted_item_type == "ANY"

func set_item(state: bool, item_texture: Texture2D = null):
	if state:
		if item_texture:
			seat.texture = item_texture
			seat.scale = Vector2(1.0, 1.0)
		else:
			pass

		is_placed = true
		hover.hide()

		item_placed_correctly.emit(self)
		print("Item placed in box seat!")
	else:
		seat.texture = SEAT
		is_placed = false

func get_placement_position() -> Vector2:
	return global_position
