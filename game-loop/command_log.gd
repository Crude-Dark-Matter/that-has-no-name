class_name CommandLog
extends Resource
# this is a stub for now, but will manage saving the command log, acting as
# the save file and saving on every command. 
# it will also handle loading game save file and emitting directly to the
# queue, bypassing the game loop

# for now store entire command object. in future maybe just command if
var _log : Array[Command]
var _event_bus : EventBus

func _init(event_bus: EventBus) -> void:
	_event_bus = event_bus
	_event_bus.log_command.connect(_on_log_command)


func _on_log_command(command: Command) -> void:
	_log.append(command)
	_event_bus.command_logged.emit(command)
