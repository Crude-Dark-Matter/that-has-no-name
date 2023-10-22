class_name ComposedCommandEdge 
extends CommandEdge


func _init(name: String, id: String, flavor_text: String, node: String, \
		conditions: Array[EdgeCondition]) -> void:
	super(name, id, flavor_text, node, conditions)
