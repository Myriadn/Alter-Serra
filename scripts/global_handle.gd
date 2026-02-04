extends Node


const AUDIO_PLAYER = preload("uid://dd2384h85s41i")

func _make_tween(obj, property, val, duration, type: int = 1):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(type)
	tween.tween_property(obj, property, val, duration)

func _play_audio(audiofile : AudioStream, parent):
	var inst = AUDIO_PLAYER.instantiate()
	inst.stream = audiofile
	parent.add_child(inst)
	
