extends Spatial

onready var _main_pine: Node = $main_pine

func get_pine_scale() -> Vector3:
	return _main_pine.scale
