## UIContext 
extends Node


## Signals to GameText
signal push_game_text(new_game_text : String)
signal clear_game_text
## Signals to MainTextContainer (wraps GameText, Items, and Notes)
signal show_items
signal hide_items
signal show_notes
signal hide_notes
## Signals to Map
signal load_map
## Signals to CommandInput
signal set_command_mode(mode : CommandMode)
signal show_command_options
signal clear_command_options
signal clear_command_text

enum CommandMode {TEXT, OPTION}

var _event_bus : EventBus


func ready() -> void:
	_event_bus = get_node("/root/EventBus")
