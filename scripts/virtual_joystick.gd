extends CanvasLayer
## Touch-anywhere virtual joystick. Exposes `direction` for Player to read.

var direction: Vector2 = Vector2.ZERO
var _touch_origin: Vector2 = Vector2.ZERO
var _active_finger: int = -1

const DEAD_ZONE := 20.0
const MAX_DISTANCE := 120.0

@onready var _base: ColorRect = $Base
@onready var _knob: ColorRect = $Knob

func _ready() -> void:
	_base.visible = false
	_knob.visible = false

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		_handle_touch(event)
	elif event is InputEventScreenDrag:
		_handle_drag(event)

func _handle_touch(event: InputEventScreenTouch) -> void:
	if event.pressed and _active_finger == -1:
		_active_finger = event.index
		_touch_origin = event.position
		_base.visible = true
		_knob.visible = true
		_base.global_position = _touch_origin - _base.size / 2.0
		_knob.global_position = _touch_origin - _knob.size / 2.0
		direction = Vector2.ZERO
	elif not event.pressed and event.index == _active_finger:
		_active_finger = -1
		direction = Vector2.ZERO
		_base.visible = false
		_knob.visible = false

func _handle_drag(event: InputEventScreenDrag) -> void:
	if event.index != _active_finger:
		return
	var offset := event.position - _touch_origin
	var dist := offset.length()
	if dist < DEAD_ZONE:
		direction = Vector2.ZERO
		_knob.global_position = _touch_origin - _knob.size / 2.0
		return
	direction = offset.normalized()
	var clamped_dist := minf(dist, MAX_DISTANCE)
	var knob_pos := _touch_origin + direction * clamped_dist
	_knob.global_position = knob_pos - _knob.size / 2.0
