class_name Utils
extends Object

static func random_in_symmetric_range(maximum: float) -> float:
	return rand_range(-maximum, maximum)

static func horizontal_part(position: Vector3) -> Vector2:
	return Vector2(position.x, position.z)
