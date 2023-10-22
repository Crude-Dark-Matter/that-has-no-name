class_name CommandQueue extends Object
# listens for requests to queue commands that are emitted by the
# CommandValidator
# currently more of a heap than a queue, but should run sequentially
# sweat_smile

var _event_bus: EventBus
var _command_log: CommandLog
var _queue: Array[Command]


func _init(event_bus: EventBus) -> void:
	_event_bus = event_bus
	_command_log = CommandLog.new(_event_bus)
	_event_bus.queue_command.connect(_on_queue_command)
	_event_bus.command_logged.connect(_on_command_logged)


func _on_queue_command(command: Command) -> void:
	_queue.append(command)
	_event_bus.log_command.emit(command)


func _on_command_logged(command: Command) -> void:
	var idx = _queue.find(command)
	_queue.remove_at(idx)
	_event_bus.parse_command.emit(command)
