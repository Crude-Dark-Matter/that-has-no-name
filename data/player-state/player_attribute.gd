class_name PlayerAttribute 
extends Resource

## All composed primitives and their influence values
@export var primitives : Array[PlayerAttributeMapping]
# these values will not be exported directly, but will be affected by a seed 
# resource whose attributes are exported
var value : float
var max_value : float
var overload_value : float
var underload_value : float
var _event_bus : EventBus
var _changed_signal = "%s_changed" % resource_name
var _overloaded_signal = "%s_overloaded" % resource_name
var _underloaded_signal = "%s_underloaded" % resource_name

# attribute does not need to emit mutation value, since nothing composes it
signal attribute_changed(val : float)
signal overloaded()
signal underloaded()


func _init() -> void:
	max_value = 0
	value = 0
	overload_value = 0
	underload_value = 0

func name() -> String:
	return resource_name


# API for StateQuery to request state of attribute
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


func connect_to_bus(e : EventBus) -> void:
	_event_bus = e
	for mapping in primitives:
		var prim = mapping.primitive
		var weight = mapping.weight
		var prim_changed_signal = "%s_changed" % prim.resource_name

		# ignore new value on primitive since that would require
		# rederiving attribute value from all mappings
		_event_bus.connect(prim_changed_signal, \
			func(_new_value, mutate_value): 
				_on_prim_changed(weight).call(mutate_value))
		
		# max value is constrained by max value of composed primitives
		max_value += abs(weight * prim.max_value)
	# these defaults will be reset by seed values
	value = max_value / 2
	overload_value = max_value * .66
	underload_value = max_value * .33

	_event_bus.attach_signal(_changed_signal, [
		{ "name": "new_value", "type": TYPE_INT}])
	
	_event_bus.attach_signal(_overloaded_signal)
	_event_bus.attach_signal(_underloaded_signal)

# needs to return a closure to keep abstracted for each mapping
func _on_prim_changed(weight: float) -> Callable:
	return func(prim_mutate_value: int):
		var attr_mutate_value
		# weighted summation of primitive values determines attr value
		# these checks shouldn't really be needed
		var new_val = value + (prim_mutate_value * weight)
		
		if (new_val >= max_value):
			value = max_value
			attr_mutate_value = new_val - value
		elif (new_val <= 0):
			value = 0
			attr_mutate_value = new_val - value
		else:
			attr_mutate_value = new_val - value
			value = new_val
		
		if attr_mutate_value != 0:
			_event_bus.emit_signal(_changed_signal, value)
		
		if value >= overload_value:
			_event_bus.emit_signal(_overloaded_signal)
		elif value <= underload_value:
			_event_bus.emit_signal(_underloaded_signal)
		else:
			return
