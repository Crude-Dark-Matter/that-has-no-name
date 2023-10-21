extends Node
# autoloaded singleton through which signals are connected and emitted
# the first loaded node and source of truth for all game signals.

# SIGNAL_STRINGS
# --------------
# constants to be used for attaching, connecting, or emitting signals
# on _event_bus
# --------------
# InteractionContext
# ------------------
# "request" is used as InteractionContext should not care whether
# requested edge or node is loaded from disk or in memory.
# an explicit "request_graph" signal is not necessary as
# InteractionContext is agnostic to the sub-graph a node or edge
# comes from. GraphLoader fills in needed "EXIT" CommandEdge and
# other super/sub-graph CommandEdge's.
signal request_command_edge(edge_id: String)
signal command_edge_returned(edge: CommandEdge)
signal request_interaction_node(node_id: String)
signal interaction_node_returned(node: InteractionNode)
# "commands_approved" is emitted when all nodes and edges of been
# returned following setting a new _current_node, approval
# of each edge has been determined and each approved edge has been
# "cast" to a Command with the Events appended from the destination node
signal commands_approved(commands: Array[Command])
# ------------------
# PlayerState
# -----------
signal player_state_readied()
# -----------
# CharacterState
#---------------
signal character_state_readied()
#---------------
# WorldState
# ----------
signal world_state_readied()
# ----------


func _ready() -> void:
	pass


func _process(_delta) -> void:
	pass


# to be used only when signal is created programatically
func attach_signal(signal_name: String, signal_arguments = []) -> void:
	add_user_signal(signal_name, signal_arguments)

