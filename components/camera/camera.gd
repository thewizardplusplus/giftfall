extends Spatial

export(float) var rotation_speed := 0.1

func _process(delta: float):
	var delta_angle := delta * rotation_speed
	Utils.vertically_rotate(self, delta_angle)
