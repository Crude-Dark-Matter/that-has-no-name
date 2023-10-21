extends Node
# InteractionContext is an autoloaded singleton through which the game graph
# is traversed. Holds pointers only to those edges and nodes on the game graph
# that are required to present and parse the next command to the player.

# pointer to current node
var _current_node : InteractionNode
# edges must be held in case conditions need to be reevaluated after interrupt
var _current_edges : Array[CommandEdge]
# commands whose edge conditions have been met and therefore evaluated
var _approved_commands : Array[Command]
# commands available from any context HELP, EXIT_GAME, SAVE
var _permanent_commands : Array[Command]

# arrays of ids not yet returned from "request_"
var _requested_edges : Array[String]
var _requested_nodes : Array[String]

var _potential_nodes : Array[InteractionNode]

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
	_event_bus.command_edge_returned.connect(_on_edge_returned)
	_event_bus.interaction_node_returned.connect(_on_node_returned)

	_permanent_commands = []
	# A last step will need to be listening for some sort of game
	# start signal


# listens for the successful parsing of the passed event message
func _on_command_parsed(command: Command) -> void :
	var next_node_id = command.get_node_id()

	# advance node pointer
	_current_node = _potential_nodes.reduce(\
			InteractionNode.find_node_by_id(next_node_id), null)
	# clear potential_nodes so that edges can update
	_potential_nodes = []
	_approved_commands = []
	_current_edges = []
	# request all edges
	_requested_edges = _current_node.get_edge_ids()
	for edge_id in _requested_edges:
		_event_bus.request_command_edge.emit(edge_id)
	# emit signal to set current interaction ui_type


# listens for the successful querying of a node
func _on_node_returned(node: InteractionNode) -> void:
	# remove id from _requested_nodes
	_requested_nodes = _requested_nodes.filter(\
			func(node_id):
				return node.get_id() != node_id)
	
	if node is InterruptInteractionNode:
		pass
		# compose with command
		# fire command immediately
	
	# if still waiting for more nodes continue listening
	# for next signal
	if _requested_nodes.size() > 0:
		return
	
	# if no remaining nodes then filter nodes
	for edge in _current_edges:
		var cond = edge.get_conditionals()
		# (gamestate_key_path: String, edge_condition_predicate: Callable)
		if cond.all(func(tuple):
			tuple[1].call(_state_query.request(tuple[0]))):
			
			# "cast" to Command
			var cmd = Command.from_edge(edge)

			# associate with the destination node and add events
			node = _potential_nodes.filter(func(n):
				return n.get_id() == edge.node_id())[0]
			cmd.add_events_from_node(node)
			
			_approved_commands.append(cmd)
	# emit signal that commands have been approved
	# this will trigger ui changes, but will likewise 
	_event_bus.commands_approved.emit(_approved_commands)


# listens for the successful querying of an edge
func _on_edge_returned(edge: CommandEdge) -> void:
	_requested_edges = _requested_edges.filter(\
			# remove the id of the incoming edge from requested edges
			func(edge_id):
				return edge.get_id() != edge_id)
	var node_id = edge.get_node_id()
	_requested_nodes.append(node_id)
	_event_bus.request_interaction_node.emit(node_id)
	if edge is SimpleCommandEdge:
		pass
	if edge is InterruptCommandEdge:
		_requested_edges = []
		# this becomes the only command available
	pass
	# remove id from _requested_edges
	# request node


# listens for insert_command_edge
# edges can only be inserted after InteractionContext has emitted a
# signal indicating it is in a state 
func _on_insert_command_edge(edge: CommandEdge) -> void:
	if edge is SimpleCommandEdge:
		pass
		# simply attach to current node
	if edge is InterruptCommandEdge:
		pass
		# evaluate Command and point resultant node toward current nodes edges 
		# re-evaluate all 
	if edge is ThunkCommandEdge:
		# convert current commands to composed commands 
		# and enclose this thunk in each
		pass
	# can only be emitted after interaction_context emits a ready signal
	# existing state must be maintained
	# if simple, 


# state reference handlers
func _on_player_state_readied() -> void : 
	_state_query.enclose($"/root/Main/PlayerState")


func _on_character_state_readied() -> void : 
	_state_query.enclose($"/root/Main/CharacterState")


func _on_world_state_readied() -> void : 
	_state_query.enclose($"/root/Main/WorldState")
