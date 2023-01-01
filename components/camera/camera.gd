extends Spatial

export(float) var rotation_speed := 0.1
export(bool) var mouse_support := true
export(float) var mouse_sensitivity := 0.001
export(float) var idle_delay := 1.0

onready var _idle_timer: Timer = $idle_timer

var _idle_mode := true

func _ready():
	if mouse_support:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float):
	if _idle_mode:
		var delta_angle := delta * rotation_speed
		Utils.vertically_rotate_node(self, delta_angle)

func _input(event: InputEvent):
	if mouse_support and event is InputEventMouseMotion:
		var delta_angle: float = event.relative.x * mouse_sensitivity
		Utils.vertically_rotate_node(self, delta_angle)

		_idle_mode = false
		_idle_timer.start(idle_delay)

func _on_idle_timer_timeout():
	_idle_mode = true
