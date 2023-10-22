class_name Command
extends Object
# represents a single package of game events, usually player initiated, but
# can be triggered by changes in game state.

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
func _init(name: String, id: String, node_id: String) -> void :
	_name = name
	_id = id
	_node_id = node_id


func get_node_id() -> String:
	return _node_id


func get_name() -> String:
	return _name


func get_events() -> Array[GameEvent]:
	return _events


# "casts" any CommandEdge to a Command preserving its sub-type in
# the Command domain.
# also creates a PUSH-FLAVOR-TEXT event from CommandEdge _flavor_text
static func from_edge(edge: CommandEdge, composed = false) -> Command:
	var name = edge._name
	var id = edge._id
	var node_id = edge._node
	var cmd
	var flavor_text_event = GameEvent.new("PUSH-FLAVOR-TEXT", \
			"ui.flavor_text", "PUSH", edge._flavor_text)
	if edge is SimpleCommandEdge:
		cmd = create(name, id, node_id, type.SIMPLE)
	elif edge is ComposedCommandEdge:
		cmd = create(name, id, node_id, type.COMPOSED)
	elif edge is ThunkCommandEdge:
		cmd = create(name, id, node_id, type.THUNK)
	else:
		cmd = create(name, id, node_id, type.SIMPLE)
	cmd._events.append(flavor_text_event)
	return cmd


func add_events_from_node(node: InteractionNode):
	_id = "%s.to.%s" % [_id, node._id]
	_events = node.get("_events")


## Factory to create the appropriately subtyped Command
static func create(name: String, id: String, node_id: String, \
		_type = type.SIMPLE) -> Command:
	match _type:
		type.SIMPLE:
			return SimpleCommand.new(name, id, node_id)
		type.INTERRUPT:
			return InterruptCommand.new(name, id, node_id)
		type.THUNK:
			return ThunkCommand.new(name, id, node_id)
		type.COMPOSED:
			return ComposedCommand.new(name, id, node_id)
		_:
			return SimpleCommand.new(name, id, node_id)

