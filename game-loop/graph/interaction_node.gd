class_name InteractionNode 
extends GraphObject
# represents a node in any graph before being composed into a Command

enum type {SIMPLE, INTERRUPT, THUNK}
enum input_type {SELECT, PROMPT, SHORT}

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

func get_edge_ids() -> Array[String]:
	return _edges

func get_id() -> String:
	return _id

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


# closure used to produce a Callable that can be passed to Array.reduce
# to find a node of a given id from an Array of nodes
static func find_node_by_id(id: String) -> Callable:
	return func(_acc, node_to_test):
		if node_to_test._id == id:
			return node_to_test
