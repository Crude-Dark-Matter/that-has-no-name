class_name InteractionNode extends Object
# represents a node in any graph before being composed into a Command

enum type {SIMPLE, INTERRUPT, THUNK}
enum input_type {SELECT, LONG, SHORT}

var _name : String
# all id's are of format n.GRAPH.UNIQUE_INT
# where GRAPH can be a path with any number of subgraphs
# eg. "n.graph_1.graph_2.graph_3.15"
var _id : String
# store id of events along with their conditions
var _edges : Array[String]
var _events : Array[GameEvent]
var _input_type : input_type


# Should never be called directly. InteractionNode.create() should be the 
# only way to instantiate 
func _init(name : String, id: String, i_type: input_type, \
		edges: Array[String], events: Array[GameEvent]) -> void:
	_name = name
	_id = id
	_input_type = i_type
	_edges = edges
	_events = events


## Factory to create the appropriately subtyped InteractionNode
static func create(name: String, id: String, i_type: input_type, \
		edges: Array[String], events: Array[GameEvent], _type = type.SIMPLE) \
		-> InteractionNode:
	match _type:
		type.SIMPLE:
			return SimpleInteractionNode.new(name, id, i_type, edges, events)
		type.INTERRUPT:
			return InterruptInteractionNode.new(name, id, i_type, edges, events)
		type.THUNK:
			return ThunkInteractionNode.new(name, id, i_type, edges, events)
		# Base case is SIMPLE
		_:
			return SimpleInteractionNode.new(name, id, i_type, edges, events)


## SUBTYPES
## --------
class SimpleInteractionNode extends InteractionNode:
	func _init(name : String, id: String, i_type: input_type,
			edges: Array[String], events: Array[GameEvent]) -> void:
		super(name, id, i_type, edges, events)


class InterruptInteractionNode extends InteractionNode:
	func _init(name : String, id: String, i_type: input_type, \
			edges: Array[String], events: Array[GameEvent]) -> void:
		super(name, id, i_type, edges, events)


class ThunkInteractionNode extends InteractionNode:
	func _init(name : String, id: String, i_type: input_type, \
			edges: Array[String], events: Array[GameEvent]) -> void:
		super(name, id, i_type, edges, events)
