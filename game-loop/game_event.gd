class_name GameEvent extends Object

var _name : String
var _key_path : String
# value cannot be statically typed
var _value : Variant


## execute event on provided EventBus
func execute(e: EventBus) -> void:
	e.emit_signal(_get_signal_string(), _value)


# returns formatted string of signal to be emitted when event 
# has finished executing
# needed by CommandParser to signal completion of all events 
# scheduled by a command
func get_completed_string() -> String:
	return ""


## formats key_path to pass to an emit_signal call
func _get_signal_string() -> String:
	return ""
