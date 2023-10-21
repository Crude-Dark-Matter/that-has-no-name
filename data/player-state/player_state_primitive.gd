class_name PlayerStatePrimitive extends Resource
# abstract functionality used by every primitive resource

## what does this primitive represent?
@export var description : String

# to be exported by seed resource in editor
var value : int
var max_value : int
var overload_value : int
var underload_value : int

var _event_bus : EventBus

# "change_$PRIMITIVE" signal emitted on bus whenever an event desires
# to mutate the value for this primitive
var _on_change_signal = "change_%s" % resource_name
# "$PRIMITIVE_changed" signal emitted on bus whenever this primitive
# successfully mutates value
var _changed_signal = "%s_changed" % resource_name

## OVERLOAD/UNDERLOAD represent extreme states of a stat
# "$PRIMITIVE_overloaded" signal emitted on bus each time this primitive
# exceeds its overload value after an attempted mutation.
var _overloaded_signal = "%s_overloaded" % resource_name
# "$PRIMITIVE_underloaded" signal emitted on bus each time this primitive
# subceeds its underload value after an attempted mutation
var _underloaded_signal = "%s_underloaded" % resource_name

func _init() -> void:
	max_value = 127
	overload_value = 100
	underload_value = 26
	value = 64


func name() -> String:
	return resource_name


# API for StateQuery to request state of primitive
func request(sub_path_arr: Array[String]) -> Variant:
	var key = sub_path_arr[0]
	match key:
		"value":
			return value
		"overloaded":
			return value >= overload_value
		"underloaded":
			return value <= underload_value
		_:
			return


func connect_to_bus(bus: EventBus) -> void:
	_event_bus = bus
	_event_bus.attach_signal(_changed_signal, [
		{ "name": "new_value", "type": TYPE_INT},
		{ "name": "mutate_value", "type": TYPE_INT}])
	_event_bus.attach_signal(_overloaded_signal)
	_event_bus.attach_signal(_underloaded_signal)
	_event_bus.attach_signal(_on_change_signal, [
		{ "name": "mutate_value", "type": TYPE_INT}])
	_event_bus.connect(_on_change_signal, _on_changed)


func _on_changed(mutate_value: int) -> void:
	# first determine whether value will change at all from previous
	var new_val = mutate_value + value
	if new_val >= max_value:
		mutate_value = max_value - value
		value = max_value
	elif new_val <= 0:
		mutate_value = value
		value = 0
	else:
		value = new_val
	
	if mutate_value != 0:
		_event_bus.emit_signal(_changed_signal, value, mutate_value)
	# it is possible to over/underload without emitting a changed value
	if value >= overload_value:
		_event_bus.emit_signal(_overloaded_signal)
	elif value <= underload_value:
		_event_bus.emit_signal(_underloaded_signal)

