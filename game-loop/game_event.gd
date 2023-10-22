class_name GameEvent extends Object

# used dictionary instead of enum to make more readable
const operation = {
	"SET": "set", 
	"CHANGE": "change", 
	}
const operation_past = {
	"SET": "set", 
	"CHANGE": "changed",
}

var _id : String
var _key_path : String
# value cannot be statically typed
var _operation : String
var _value : Variant


func _init(id: String, key_path: String, op: String, value: Variant) -> void:
	_id = id
	_key_path = key_path.replace(".", "_")
	_operation = op


func get_id() -> String:
	return _id


## execute event on provided EventBus
func execute(e: EventBus) -> void:
	e.connect(_get_completed_string(), _on_completed_event(e))
	e.emit_signal(_get_signal_string(), _value)


func _get_completed_string() -> String:
	return "%s_%s" % [_key_path, operation_past[_operation]]


## formats key_path to pass to an emit_signal call
func _get_signal_string() -> String:
	return "%s_%s" % [operation[_operation], _key_path]


func _on_completed_event(e: EventBus) -> Callable:
	return func() -> void:
		e.game_event_executed.emit(_id)
		# must clean up signals to prevent duplicated messages later
		e.disconnect(_get_completed_string(), _on_completed_event(e))
		free()
