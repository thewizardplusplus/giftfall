extends Spatial

const HTerrain = preload("res://addons/zylann.hterrain/hterrain.gd")

onready var _terrain: HTerrain = $terrain

func get_interpolated_height_at(position: Vector3) -> float:
	position = _terrain.get_internal_transform().xform_inv(position)
	return _terrain.get_data().get_interpolated_height_at(position)
