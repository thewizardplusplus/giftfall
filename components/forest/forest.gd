extends Spatial

const Pine: PackedScene = preload("res://components/pine/pine.tscn")

export(int) var pine_count := 1000
export(float) var main_pine_margin := 50.0

onready var _terrain: Node = $terrain
onready var _main_pine: Node = $main_pine

func _ready():
	randomize()

	_terrain.put_on_terrain(_main_pine)

	var half_terrain_resolution: int = _terrain.get_resolution() / 2
	var main_pine_horizontal_position := Utils.horizontal_part(_main_pine.transform.origin)
	for index in range(0, pine_count):
		var pine := Pine.instance()
		pine.name = "_generated_pine_%d" % index
		pine.scale = _main_pine.scale

		pine.transform = pine.transform.rotated(Vector3.UP, deg2rad(rand_range(0, 360)))

		while true:
			var x := Utils.random_in_symmetric_range(half_terrain_resolution)
			var z := Utils.random_in_symmetric_range(half_terrain_resolution)
			if Vector2(x, z).distance_to(main_pine_horizontal_position) > main_pine_margin:
				pine.transform.origin.x = x
				pine.transform.origin.z = z

				break

		_terrain.put_on_terrain(pine)

		get_parent().call_deferred("add_child", pine)
