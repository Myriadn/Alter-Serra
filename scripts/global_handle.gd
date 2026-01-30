extends Node




func _make_tween(obj, property, val, duration, type: int = 1):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(type)
	tween.tween_property(obj, property, val, duration)
