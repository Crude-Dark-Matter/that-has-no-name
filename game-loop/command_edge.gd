class_name CommandEdge extends Object
# represents an edge in any graph before being composed into a Command

enum type {SIMPLE, INTERRUPT, THUNK}

var _name : String
# all id's are of format e.GRAPH.UNIQUE_INT
# where GRAPH can be a path with any number of subgraphs
# eg. "e.graph_1.graph_2.graph_3.15"
var _id : String
# store id of connected InteractionNode
var _node : String
# condition to evaluate to true to validate edge
var _condition : EdgeCondition


func _init(name: String, id: String, node: String, \
		condition: EdgeCondition) -> void:
	_name = name
	_id = id
	_node = node
	_condition = condition


## Factory to create the appropriately subtyped CommandEdge
static func create(_type: type, name: String, id: String, \
		node: String, condition: EdgeCondition) -> CommandEdge:
	match _type:
		type.SIMPLE:
			return SimpleCommandEdge.new(name, id, node, condition)
		type.INTERRUPT:
			return InterruptCommandEdge.new(name, id, node, condition)
		type.THUNK:
			return ThunkCommandEdge.new(name, id, node, condition)
		_:
			return SimpleCommandEdge.new(name, id, node, condition)


## SUBTYPES
## --------
class SimpleCommandEdge extends CommandEdge:
	func _init(name: String, id: String, node: String, \
			condition: EdgeCondition) -> void:
		super(name, id, node, condition)


class InterruptCommandEdge extends CommandEdge:
	func _init(name: String, id: String, node: String, \
			condition: EdgeCondition) -> void:
		super(name, id, node, condition)


class ThunkCommandEdge extends CommandEdge:
	func _init(name: String, id: String, node: String, \
			condition: EdgeCondition) -> void:
		super(name, id, node, condition)


## INTERNALTYPE
## ------------
class EdgeCondition extends Object:
	enum comparator {LESS, LESS_EQUAL, EQUAL, GREATER_EQUAL, GREATER}

	var _key_path : String
	var _value : String
	var _comparator : comparator
	# comparand can't be statically typed 
	# as it can be any value paired to a state key
	var _comparand : Variant
