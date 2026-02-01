extends CanvasLayer

@onready var version: Label = $Control/LeftPanel/version

func _ready() -> void:
	version.text = ProjectSettings.get_setting("application/config/version")
	
func _on_start_button_press(button_node: Variant) -> void:
	SceneManager._change_scene_w_day_count("res://scenes/levels/master/day1/day1_morning.tscn", 1)

func _on_quit_button_press(button_node: Variant) -> void:
	get_tree().quit()
