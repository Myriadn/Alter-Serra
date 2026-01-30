extends StaticBody2D
class_name PickupItem


@export var item_name: String = "Barang Placeholder"
var is_held: bool = false

func _physics_process(_delta: float) -> void:
	if is_held:
		# Jika sedang dibawa, matikan collision agar tidak tabrakan dengan Player
		# Kita akan update posisi lewat script Player saja agar lebih smooth
		pass
