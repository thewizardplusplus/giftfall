extends Spatial

const Pine: PackedScene = preload("res://components/pine/pine.tscn")

export(int) var pine_count := 1000
export(float) var main_pine_margin := 50.0

onready var _terrain: Node = $terrain
onready var _main_pine: Node = $main_pine

func _ready():
	randomize()

	_terrain.put_on_terrain(_main_pine)

	for index in range(0, pine_count):
		var pine := self._generate_random_pine(index)
		get_parent().call_deferred("add_child", pine)

func _generate_random_pine(index: int) -> Node:
	var pine := Pine.instance()
	pine.name = "_generated_pine_%d" % index
	pine.scale = _main_pine.get_pine_scale()

	Utils.vertically_rotate(pine, rand_range(0, 2 * PI))

	self._set_random_position(pine)
	_terrain.put_on_terrain(pine)

	return pine

func _set_random_position(pine: Node):
	var half_terrain_resolution: int = _terrain.get_resolution() / 2
	var main_pine_horizontal_position := Utils.horizontal_part(_main_pine.transform.origin)

	while true:
		var pine_x := Utils.random_in_symmetric_range(half_terrain_resolution)
		var pine_z := Utils.random_in_symmetric_range(half_terrain_resolution)

		if Vector2(pine_x, pine_z).distance_to(main_pine_horizontal_position) > main_pine_margin:
			pine.transform.origin.x = pine_x
			pine.transform.origin.z = pine_z

			break
