@tool
extends StaticBody2D

@onready var timer_cleansing: Timer = $TimerCleansing
@onready var sprite: Sprite2D = $Sprite2D
enum task_name {NODA, BARANG, BOX, RACK}
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
const RACK = preload("uid://cro2141m6rpk7")

# task config
# Collision layer info:
	# 2 for cleanble,
	# 3 for pickup things
const TASK_CONFIG = {
	task_name.NODA: {
		"texture": NODA,
		"collision_layer": 2,
		"cleanable": true,
		"pickable": false
	},
	task_name.BARANG: {
		"texture": BARANG,
		"collision_layer": 2,
		"cleanable": true,
		"pickable": false
	},
	task_name.BOX: {
		"texture": BOX,
		"collision_layer": 3,
		"cleanable": false,
		"pickable": true
	},
	task_name.RACK: {
		"texture": RACK,
		"collision_layer": 2,
		"cleanable": true,
		"pickable": false
	}
}

func _ready() -> void:
	update_preview()

func update_preview():
	if not sprite:
		sprite = get_node_or_null("Sprite2D")
	if task_type in TASK_CONFIG:
		var config = TASK_CONFIG[task_type]
		if sprite:
			sprite.texture = config["texture"]
			if sprite.texture:
				var collision_shape = get_node_or_null("CollisionShape2D")
				if collision_shape and collision_shape.shape:
					var shape_size = collision_shape.shape.get_rect().size
					var texture_size = sprite.texture.get_size()

					# Scale sprite to fit collision
					sprite.scale = shape_size / texture_size

func can_be_cleaned() -> bool: # objek yang bisa di bersihkan
	if task_type in TASK_CONFIG:
		return TASK_CONFIG[task_type].get("cleanable", false)
	return false

func can_be_picked() -> bool: # fungsi buat objek yang bisa di interaksi
	if task_type in TASK_CONFIG:
		return TASK_CONFIG[task_type].get("pickable", false)
	return false

func get_task_name_string() -> String: # buat keterbacaan task
	return task_name.keys()[task_type]

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
