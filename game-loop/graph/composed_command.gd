class_name ComposedCommand extends Command
# ComposedCommand is identical to a SimpleCommand, except it encloses a
# ThunkCommand to be executed by the CommandParser first.


var _enclosed_thunk : ThunkCommand


func _init(name: String, id: String, node_id: String) -> void:
	super(name, id, node_id)


func enclose_thunk(thunk: ThunkCommand) -> void:
	_enclosed_thunk = thunk
