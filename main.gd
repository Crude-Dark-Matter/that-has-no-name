extends Node
# Main scene coordinates aspects of the game loop that are not singletons

var _command_parser : CommandParser
var _command_queue : CommandQueue
var _command_validator : CommandValidator

var _event_bus : EventBus

func _ready() -> void:
	_event_bus = get_node("/root/EventBus")
	
	_command_parser = CommandParser.new(_event_bus)
	_command_queue = CommandQueue.new(_event_bus)
	_command_validator = CommandValidator.new(_event_bus)

