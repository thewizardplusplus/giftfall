extends Spatial

const Bauble: PackedScene = preload("res://components/bauble/bauble.tscn")
const target_distance := 100

export(Array, Color) var colors := [
	Color(1, 0, 0),
	Color(0, 1, 0),
	Color(0, 0, 1),
]
export(float) var minimal_height := 0.0
export(float) var maximal_height := 100.0
export(float) var height_step := 1.0
export(NodePath) var base_model_path

var base_model: Spatial = null
var is_initialized := false

func _ready():
	if len(colors) == 0:
		printerr("baubles: colors aren't specified")
		return

	base_model = get_node(base_model_path)
	if base_model == null:
		printerr("baubles: base model isn't specified")
		return
	if not (base_model is Spatial):
		printerr("baubles: base model isn't Spatial")
		return

func _physics_process(_delta: float):
	if base_model == null:
		return
	
	if not is_initialized:
		_initialize()
		is_initialized = true

func _initialize():
	var height := minimal_height
	var index := 0
	while height < maximal_height:
		var t := rand_range(0, 2 * PI)
		var direction := Vector3.RIGHT.rotated(Vector3.UP, t)

		var origin := base_model.global_transform.origin + Vector3.UP * height
		var target := origin + direction * target_distance
		var hit_position := _intersect_ray(target, origin) # reverse direction
		if hit_position != Vector3.ZERO:
			_add_bauble(index, hit_position)
		else:
			printerr("baubles: there isn't an intersection at height %f" % height)

		height += height_step
		index += 1

func _intersect_ray(origin: Vector3, target: Vector3) -> Vector3:
	var world := get_world()
	var hit_info := world.direct_space_state.intersect_ray(origin, target)
	return hit_info["position"] if len(hit_info) != 0 else Vector3.ZERO

func _add_bauble(index: int, position: Vector3):
	var bauble := Bauble.instance()
	bauble.name = "_generated_bauble_%d" % index
	bauble.transform.origin = position
	bauble.color = Utils.random_choice(colors)

	get_parent().call_deferred("add_child", bauble)
