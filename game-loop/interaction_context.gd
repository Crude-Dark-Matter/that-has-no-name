# autoloaded singleton through which interactions are loaded
# must have visibility on player state, world state, and character state
extends Node

signal set_command_input_type()
signal set_command_options(command_options: Array)
signal load_graph(graph_id: String)

var _nodes : Dictionary
var _edges : Dictionary
var _current_node : InteractionNode
var _current_commands : Array[Command]
var _selected_command : int
# External Nodes
var _event_bus : EventBus
var _player_state : PlayerState
var _character_state : CharacterState
var _world_state : WorldState


func _ready() -> void : 
	_event_bus = get_node("/root/EventBus")
	
	# Hook up state references
	_event_bus.attach_signal("player_state_loaded")
	_event_bus.connect("player_state_loaded", _on_player_state_loaded)
	_event_bus.attach_signal("character_state_loaded")
	_event_bus.connect("character_state_loaded", _on_character_state_loaded)
	_event_bus.attach_signal("world_state_loaded")
	_event_bus.connect("world_state_loaded", _on_world_state_loaded)


# listens for the successful parsing of the passed event message
func _on_command_parsed() -> void : 
	# advance node pointer
	pass
	# if necessary load_graph


# state reference handlers
func _on_player_state_loaded() -> void : 
	_player_state = $"/root/Main/PlayerState"


func _on_character_state_loaded() -> void : 
	_character_state = $"/root/Main/CharacterState"


func _on_world_state_loaded() -> void : 
	_world_state = $"/root/Main/WorldState"
