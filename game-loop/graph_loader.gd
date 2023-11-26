extends Node
# GraphLoader is an autoloaded singleton that is responsible for keeping 
# elements of the story graph in memory and retrieving them from disk.
# also facilitates the attachment of subgraphs to the current InteractionContext
# when conditions are met.

var _res_regex 

var _cache : Cache
var _response : Array

var _event_bus : EventBus

func _ready() -> void:
	_res_regex = RegEx.new().compile(".*(?=\\.[ne]\\.*.)")
	_cache = Cache.new(_res_regex)

	_event_bus = get_node("/root/EventBus")

	_event_bus.request_command_edges.connect(_on_request_command_edges)
	_event_bus.request_interaction_nodes.connect(_on_request_interaction_nodes)
	_event_bus.commands_approved.emit(_on_commands_approved)


func _on_request_command_edges(edge_ids: Array[String]) -> void:
	var response: Array[CommandEdge]
	response = _lookup_command_edge_batch(edge_ids)
	_event_bus.command_edges_returned.emit(response)

func _on_request_interaction_nodes(node_ids: Array[String]) -> void:
	print(node_ids)
	_response = _lookup_batch(node_ids)
	_event_bus.interaction_nodes_returned.emit(_response)
	_response.clear()

# can't reuse this exactly, because GraphObject is not being cast to its
# subtypes appropriately
func _lookup_command_edge_batch(edge_ids: Array[String]) \
			-> Array[CommandEdge]:
	var response: Array[CommandEdge]
	var to_load = edge_ids.reduce(func(_load, edge_id):
			var edge = _cache.retrieve_edge(edge_ids)
			if edge: response.append(edge)
			else: _load.append(edge_id)
			return _load, [])
	if to_load.is_empty() != true:
		return response
	# ensure not loading from the same resource multiple times
	else:
		var resources = to_load.reduce(func(res_map, to_load_id):
				var res_path = "res://interactions/%s.json" \
					% _res_regex.search(to_load_id)
				res_map[res_path] = true
				return res_map
				, {})
		for res in resources:
			# eventually multi-thread?
			_load_from_disk(res)
		for edge_id in to_load:
			response.append(_cache.retrieve(edge_id))
		return response
# this is duplicated code from _lookup_command_edge_batch
# if one is broken, both must be inspected
func _lookup_interaction_node_batch(node_ids: Array[String]) \
			-> Array[InteractionNode]:
	var response: Array[InteractionNode]
	var to_load = node_ids.reduce(func(_load, node_id):
			var node = _cache.retrieve_node(node_ids)
			if node: response.append(node)
			else: _load.append(node_id)
			return _load, [])
	if to_load.is_empty() != true:
		return response
	# ensure not loading from the same resource multiple times
	else:
		var resources = to_load.reduce(func(res_map, to_load_id):
				var res_path = "res://interactions/%s.json" \
					% _res_regex.search(to_load_id)
				res_map[res_path] = true
				return res_map
				, {})
		for res in resources:
			# eventually multi-thread?
			_load_from_disk(res)
		for node_id in to_load:
			response.append(_cache.retrieve(node_id))
		return response

# indicates that InteractionContext is open to having subgraph inserted
func _on_commands_approved(_commands) -> void:
	pass


# load graph resource from disk
# realizing the need for a GraphResource type that is inherited by Edges,
# Nodes (and maybe Commands)
func _load_from_disk(res_id: String) -> void:
	# load JSON from file path
	# parse JSON and construct GraphObjects from graph
	# store graph objects in cache
	# return selected resource
	return


class Cache extends Object:
	var _cache: Dictionary
	var _res_regex: RegExp
	
	func _init(res_regex: RegExp) -> void:
		_res_regex = res_regex

	func retrieve_edge(edge_id: String) -> CommandEdge:
		# get graph from edge_id
		var cache_key = _res_regex.search(edge_id)
		if _cache.has(cache_key):
			return _cache[cache_key].retrieve_edge(edge_id)
		else:
			return

	func retrieve_node(obj_id: String) -> InteractionNode:
		# get graph from obj_id
		return


class GraphCache extends Object:
	var _last_hit: int
	var _graph_objects: Dictionary
