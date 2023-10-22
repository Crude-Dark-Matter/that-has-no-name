class_name CommandParser extends Object
# listens for commands emitted from queue and parses into game events
# to be emitted in series

var _event_bus: EventBus
var _event_table: Dictionary
var _command: Command
var _composed_command: ComposedCommand


func _init(event_bus: EventBus) -> void:
	_event_bus = event_bus
	_event_bus.parse_command.connect(_on_parse_command)
	_event_bus.game_event_executed.connect(_on_game_event_executed)


func _on_parse_command(command: Command) -> void:
	if command is ComposedCommand:
		_composed_command = command
		_command = command.get_thunk()
	else:
		_command = command
	_parse_command()


func _parse_command() -> void:
	var events = _command.get_events()
	for event in events:
		_event_table[event.get_id()] = null
	for event in events:
		event.execute(_event_bus)


func _on_game_event_executed(event_id: String) -> void:
	_event_table.erase(event_id)
	if _event_table.is_empty():
		if _command is ThunkCommand:
			_command = _composed_command
			_composed_command = null
			_parse_command()
		else: 
			_event_bus.command_parsed.emit(_command)
			_command = null
