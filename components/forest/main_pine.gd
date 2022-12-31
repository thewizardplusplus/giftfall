extends Spatial

onready var _terrain: Node = get_tree().get_root().get_node("/root/root/terrain")

func _ready():
	self.transform.origin.y = _terrain.get_interpolated_height_at(self.transform.origin)
