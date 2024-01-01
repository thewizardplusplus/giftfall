class_name Utils
extends Object

static func random_in_symmetric_range(maximum: float) -> float:
	return rand_range(-maximum, maximum)

static func random_choice(elements: Array) -> Object:
	return elements[randi() % len(elements)]

static func horizontal_part(position: Vector3) -> Vector2:
	return Vector2(position.x, position.z)

static func vertically_rotate(node: Node, delta_angle: float):
	node.transform = node.transform.rotated(Vector3.UP, delta_angle)
