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
func _init(name: String, id: String, node_id: String) -> void :
	_name = name
	_id = id
	_node_id = node_id


func get_node_id() -> String:
	return _node_id


static func from_edge(edge: CommandEdge, composed = false) -> Command:
	var name = edge._name
	var id = edge._id
	var node_id = edge._node
	if edge is SimpleCommandEdge:
		# Edges are not typed COMPOSED, SIMPLE edges yield composed
		# commands when following THUNK nodes
		if composed == true:
			return create(name, id, node_id, type.COMPOSED)
		return create(name, id, node_id, type.SIMPLE)
	elif edge is InterruptCommandEdge:
		return create(name, id, node_id, type.INTERRUPT)
	elif edge is ThunkCommandEdge:
		return create(name, id, node_id, type.THUNK)
	else:
		return create(name, id, node_id, type.SIMPLE)


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

