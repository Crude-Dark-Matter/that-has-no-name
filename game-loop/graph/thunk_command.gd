class_name ThunkCommand extends Command
# ThunkCommand is a command to be enclosed by a ComposedCommand
# and executed by the CommandParser before executing it's enclosing
# ComposedCommand


func _init(name: String, id: String, node_id: String) -> void:
	super(name, id, node_id)
