class_name Command extends Object

enum type {SIMPLE, INTERRUPT, THUNK, COMPOSED}


# takes name from CommandEdge
var _name : String
# composition of Edge and destination Node ids
# EDGE_ID.to.NODE_ID
var _id : String

# id of node is stored to avoid circular references and enhance composability
var _node_id : String
var _events : Array[GameEvent]


# Should never be called directly. Command.create() should be the 
# only way to instantiate 
func _init(name: String, id: String, node_id: String, \
		events: Array[GameEvent]) -> void :
	_name = name
	_id = id
	_node_id = node_id
	_events = events


## Factory to create the appropriately subtyped Command
static func create(name: String, id: String, node_id: String, \
		events: Array[GameEvent], _type = type.SIMPLE) -> Command:
	match _type:
		type.SIMPLE:
			return SimpleCommand.new(name, id, node_id, events)
		type.INTERRUPT:
			return InterruptCommand.new(name, id, node_id, events)
		type.THUNK:
			return ThunkCommand.new(name, id, node_id, events)
		type.COMPOSED:
			return ComposedCommand.new(name, id, node_id, events)
		_:
			return SimpleCommand.new(name, id, node_id, events)


## SUBTYPES
## --------
# SimpleCommand is the canonical example of a command
class SimpleCommand extends Command:
	func _init(name: String, id: String, node_id: String, \
			events: Array[GameEvent]) -> void:
		super(name, id, node_id, events)


# InterruptCommand is a command to be selected by 
# the CommandValidator immediately
class InterruptCommand extends Command:
	func _init(name: String, id: String, node_id: String, \
			events: Array[GameEvent]) -> void:
		super(name, id, node_id, events)


# ThunkCommand is a command to be enclosed by a ComposedCommand
# and executed by the CommandParser before executing it's enclosing
# ComposedCommand
class ThunkCommand extends Command:
	func _init(name: String, id: String, node_id: String, \
			events: Array[GameEvent]) -> void:
		super(name, id, node_id, events)


# ComposedCommand is identical to a SimpleCommand, except it encloses a
# ThunkCommand to be executed by the CommandParser first.
class ComposedCommand extends Command:
	var _enclosed_thunk : ThunkCommand

	func _init(name: String, id: String, node_id: String, \
			events: Array[GameEvent]) -> void:
		super(name, id, node_id, events)
	
	func enclose_thunk(thunk: ThunkCommand) -> void:
		_enclosed_thunk = thunk
