@tool
extends StaticBody2D

@onready var timer_cleansing: Timer = $TimerCleansing
@onready var sprite: Sprite2D = $Sprite2D
enum task_name {NODA, BARANG, BOX}
@export var task_type : task_name = task_name.NODA :
	set(val):
		task_type = val
		if Engine.is_editor_hint() and is_inside_tree():
			update_preview()
	get:
		return task_type
@export var cleaning_duration : float = 1.0

const BARANG = preload("uid://b1ns5qv0y7ttm")
const BOX = preload("uid://5jwrcqoqsm4i")
const NODA = preload("uid://p61xbr3ruo6q")

func _ready() -> void:
	update_preview()

func update_preview():
	if task_type == task_name.NODA:
		set_collision_layer_value(2, true)
		sprite.texture = NODA
	elif task_type == task_name.BARANG:
		set_collision_layer_value(2, true)
		sprite.texture = BARANG
	elif task_type == task_name.BOX:
		set_collision_layer_value(3, true)
		sprite.texture = BOX
	else :
		return

func pick_box(_body):
	queue_free()

var clean_timer = 0.0
func cleansing():
	clean_timer = 0.0
	timer_cleansing.start()

func do_failure():
	timer_cleansing.stop()
	clean_timer = 0.0

func do_success():
	queue_free()

func _on_timer_cleansing_timeout() -> void:
	clean_timer += 0.1
