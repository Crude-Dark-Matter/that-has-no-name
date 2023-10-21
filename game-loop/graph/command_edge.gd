class_name CommandEdge 
extends Object
# represents an edge in any graph before being composed into a Command

enum type {SIMPLE, INTERRUPT, THUNK}

var _name : String
# all id's are of format e.GRAPH.UNIQUE_INT
# where GRAPH can be a path with any number of subgraphs
# eg. "e.graph_1.graph_2.graph_3.15"
var _id : String
# text to be displayed when command is evaluated
var _flavor_text: String
# store id of connected InteractionNode
var _node : String
# conditions which must all to evaluate to true to validate edge
var _conditions : Array[EdgeCondition]


func _init(name: String, id: String, flavor_text: String, node: String, \
		conditions: Array[EdgeCondition]) -> void:
	_name = name
	_id = id
	_flavor_text = flavor_text
	_node = node
	_conditions = conditions


## Factory to create the appropriately subtyped CommandEdge
static func create(_type: type, name: String, id: String, \
		flavor_text: String, node: String, \
		conditions: Array[EdgeCondition]) -> CommandEdge:
	match _type:
		type.SIMPLE:
			return SimpleCommandEdge.new(name, id, \
					flavor_text, node, conditions)
		type.INTERRUPT:
			return InterruptCommandEdge.new(name, id, \
					flavor_text, node, conditions)
		type.THUNK:
			return ThunkCommandEdge.new(name, id, \
					flavor_text, node, conditions)
		_:
			return SimpleCommandEdge.new(name, id, \
					flavor_text, node, conditions)


func get_id() -> String:
	return _id


func get_node_id() -> String:
	return _node


# (gamestate_key_path: String, edge_condition_predicate: Callable)
func get_conditionals() -> Array:
	# i really wish this language supported tuples
	return _conditions.map(func(condition):
		return [
			condition.key_path(), 
			condition.predicate()
		])


## INTERNALTYPE
## ------------
class EdgeCondition extends Object:
	enum comparator {LESS, LESS_EQUAL, EQUAL, GREATER_EQUAL, GREATER, NOT_EQUAL}

	var _key_path : String
	var _comparator : comparator
	# comparand can't be statically typed 
	# as it can be any value paired to a state key
	var _comparand : Variant

	func key_path() -> String:
		return _key_path

	func get_predicate() -> Callable:
		match _comparator:
			comparator.LESS:
				return func(val: Variant) -> bool:
					return val < _comparand
			comparator.LESS_EQUAL:
				return func(val: Variant) -> bool:
					return val <= _comparand
			comparator.EQUAL:
				return func(val: Variant) -> bool:
					return val == _comparand
			comparator.GREATER_EQUAL:
				return func(val: Variant) -> bool:
					return val >= _comparand
			comparator.GREATER:
				return func(val: Variant) -> bool:
					return val > _comparand
			comparator.NOT_EQUAL:
				return func(val: Variant) -> bool:
					return val != _comparand
			# base case always evaluates to true
			_:
				return func(_val: Variant) -> bool:
					return true
