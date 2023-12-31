extends Spatial

export(Color) var color := Color(1, 1, 1)

onready var _bauble: MeshInstance = $bauble

func _ready():
	var surface_material := _bauble.get_surface_material(0)
	surface_material.albedo_color = color
