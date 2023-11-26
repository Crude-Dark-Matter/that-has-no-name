extends Node
# autoloaded singleton through which signals are connected and emitted
# the first loaded node and source of truth for all game signals.

# SIGNAL_STRINGS
# --------------
# constants to be used for attaching, connecting, or emitting signals
# on _event_bus
# --------------
# Main
# ____
# Used to bring up debug panel for event bus. this allows emission of any
# event on the event bus.
signal start_debug()
signal stop_debug()
# ____
# GraphLoader
# -----------
signal insert_command_edges(edges: Array[String])
# GraphLoader must guarantee that any Interrupt is first in list
# and any Thunk is last in list. there can be no more than 1 of 
# either in any portion of the graph
signal command_edges_returned(edges: Array[CommandEdge])
signal interaction_nodes_returned(nodes: Array[InteractionNode])
# -----------
# InteractionContext
# ------------------
# "request" is used as InteractionContext should not care whether
# requested edge or node is loaded from disk or in memory.
# an explicit "request_graph" signal is not necessary as
# InteractionContext is agnostic to the sub-graph a node or edge
# comes from. GraphLoader fills in needed "EXIT" CommandEdge and
# other super/sub-graph CommandEdge's.
signal request_command_edges(edge_ids: Array[String])
signal request_interaction_nodes(node_ids: Array[String])
# "commands_approved" is emitted when all nodes and edges of been
# returned following setting a new _current_node, approval
# of each edge has been determined and each approved edge has been
# "cast" to a Command with the Events appended from the destination node
signal commands_approved(commands: Array[Command])
signal command_approval_revoked()
# interrupts can be queued out of order
signal queue_interrupt_command(command: Command)
# ------------------
# PlayerCommandInput
# ------------------
# attempt is a String representation of PlayerInput. it is agnostic to the
# input_type on the current InteractionNode
signal issue_player_command_attempt(attempt: String)
# ------------------
# CommandValidator
# ----------------
signal player_command_attempt_failed()
# emitted when a command attempt has been validated and selected, used by ui.
# commands can be queued without player intervention
signal select_validated_command(command: Command)
# emitted after select_validated_command, listened by command_queue
signal queue_command(command: Command)
# ----------------
# CommandQueue
# ------------
signal command_queued(command: Command)
signal log_command(command: Command)
signal parse_command(command: Command)
# ------------
# CommandLog
# ----------
signal command_logged(command: Command)
# ----------
# CommandParser
# -------------
signal command_parsed(command: Command)
# -------------
# GameEvent
# ---------
signal game_event_executed(event_id: String)
# ---------
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
	start_debug.connect(_on_start_debug)
	stop_debug.connect(_on_stop_debug)


# to be used only when signal is created programatically
func attach_signal(signal_name: String, signal_arguments = []) -> void:
	add_user_signal(signal_name, signal_arguments)


# for debugging signals
func _on_start_debug() -> void:
	pass


func _on_stop_debug() -> void:
	pass
