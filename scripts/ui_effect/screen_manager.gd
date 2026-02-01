extends CanvasLayer

@onready var anim: AnimationPlayer = $Control/AnimationPlayer
@onready var label: Label = $Control/Label

func _ready() -> void:
	label.hide()
	label.modulate.a = 1.0

func _change_scene(path : String = ""):
	layer = 10

	anim.play("Fadew")
	await anim.animation_finished
	if path != "" :
		get_tree().change_scene_to_file(path)
	anim.play_backwards("Fadew")
	await anim.animation_finished
	layer = 0

func _change_scene_w_day_count(path : String = "", day_count : int = 0):
	layer = 10

	label.text = "DAY " + str(day_count)
	anim.play("Fadew")
	await anim.animation_finished

	label.modulate.a = 1.0
	label.show()
	await get_tree().create_timer(2.0).timeout

	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 0.8)
	await tween.finished

	label.hide()

	if path != "" :
		get_tree().change_scene_to_file(path)

	await get_tree().process_frame

	anim.play_backwards("Fadew")
	await anim.animation_finished
	layer = 0
