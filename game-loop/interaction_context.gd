extends Node
# InteractionContext is an autoloaded singleton through which the game graph
# is traversed. Holds pointers only to those edges and nodes on the game graph
# that are required to present and parse the next command to the player.

# pointer to current node
var _current_node : InteractionNode
# edges must be held in case conditions need to be reevaluated 
# after inserted interrupt
var _current_edges : Array[CommandEdge]
var _potential_nodes : Array[InteractionNode]
# if there is a thunk it is held so that a new batch of edges can be requested
# and cast to ComposedCommandEdges
var _thunk : Command
# commands whose edge conditions have been met and therefore evaluated
var _approved_commands : Array[Command]
# commands available from any context HELP, EXIT_GAME, SAVE
var _permanent_commands : Array[Command]


# External Nodes/Objects
var _event_bus : EventBus
var _state_query : StateQuery


func _ready() -> void : 
	_event_bus = get_node("/root/EventBus")

	_state_query = StateQuery.new()	
	# Hook up state references
	# InteractionContext is loaded before state nodes, therefore it
	# is responsible for attaching signals. Once each has completed
	# _ready() call they emit the signal and InteractionContext captures
	# a reference for querying them for state.
	_event_bus.player_state_readied.connect(_on_player_state_readied)
	_event_bus.character_state_readied.connect(_on_character_state_readied)
	_event_bus.world_state_readied.connect(_on_world_state_readied)

	# Connect methods that respond returned graph components
	_event_bus.command_edges_returned.connect(_on_edges_returned)
	_event_bus.interaction_nodes_returned.connect(_on_nodes_returned)

	_permanent_commands = []
	# A last step will need to be listening for some sort of game
	# start signal


# listens for the successful parsing of the passed event message
func _on_command_parsed(command: Command) -> void :
	var next_node_id = command.get_node_id()
	# advance node pointer
	_current_node = _potential_nodes.reduce(\
			InteractionNode.find_node_by_id(next_node_id), null)
	# clear all untraversed parts of the graph
	_potential_nodes = []
	_approved_commands = []
	_current_edges = []
	_thunk = null
	# request all edges
	var edge_ids = _current_node.get_edge_ids()
	_event_bus.request_command_edges.emit(edge_ids)


# listens for the successful querying of a batch of nodes
func _on_nodes_returned(nodes: Array[InteractionNode]) -> void:
	# Guaranteed to prepend interrupt nodes and edges
	if nodes[0] is InterruptInteractionNode:
		var edge = _current_edges[0]
		var cmd = Command.from_edge(edge)
		cmd.add_events_from_node(cmd)

		# fire command immediately
		_event_bus.queue_interrupt_command.emit(cmd)
		return
	
	# if node is thunk, it must be the last to be returned
	# it must queue additional 
	if nodes[-1] is ThunkInteractionNode:
		var edge = _current_edges[0]
		var cmd = Command.from_edge(edge)
		cmd.add_events_from_node(cmd)
		_thunk = cmd
		_current_edges.remove_at(-1)
		_potential_nodes = nodes.slice(0, -1)
		# request new batch of edges
		var edge_ids = _current_node.get_edge_ids()
		_event_bus.request_command_edges.emit(edge_ids)
		return
	
	_potential_nodes = nodes

	for i in _current_edges.size():
		var edge = _current_edges[i]
		var node = _potential_nodes[i]
		var cond = edge.get_conditionals()
		# (gamestate_key_path: String, edge_condition_predicate: Callable)
		if cond.all(func(tuple):
			tuple[1].call(_state_query.request(tuple[0]))):
			
			# "cast" to Command
			var cmd = Command.from_edge(edge)
			cmd.add_events_from_node(node)
			
			# a composed edge will cast to a ComposedCommand
			if cmd is ComposedCommand:
				cmd.enclose_thunk(_thunk)
			
			_approved_commands.append(cmd)
	# emit signal that commands have been approved
	# this will trigger ui changes, but will likewise
	
	_event_bus.commands_approved.emit(_approved_commands)


# listens for the successful querying of a batch of edges
func _on_edges_returned(edges: Array[CommandEdge]) -> void:
	var requested_nodes = edges.map(func(edge): return edge.get_node_id())
	# request node for adding events to resultant command
	_event_bus.request_interaction_nodes.emit(requested_nodes)
	if _thunk:
		edges = edges.map(func(edge): 
				return CommandEdge.to_composed_edge(edge))
		_current_edges.append_array(edges)
		return
	_current_edges = edges


# listens for insert_command_edges
# edges can only be inserted after InteractionContext has emitted a
# signal indicating it is in a state 
func _on_insert_command_edges(edge: Array[CommandEdge]) -> void:
	if edge[0] is SimpleCommandEdge:
		pass
		# simply attach to current node
	if edge[0] is InterruptCommandEdge:
		pass
		# evaluate Command and point resultant node toward current nodes edges 
		# re-evaluate all 
	if edge[0] is ThunkCommandEdge:
		# convert current commands to composed commands 
		# and enclose this thunk in each
		pass
	# can only be emitted after interaction_context emits a ready signal
	# in the form of commands_approved
	# existing state must be maintained
	# if simple, 


# state reference handlers
func _on_player_state_readied() -> void : 
	_state_query.enclose($"/root/Main/PlayerState")


func _on_character_state_readied() -> void : 
	_state_query.enclose($"/root/Main/CharacterState")


func _on_world_state_readied() -> void : 
	_state_query.enclose($"/root/Main/WorldState")
