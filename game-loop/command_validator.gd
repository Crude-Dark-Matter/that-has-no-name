class_name CommandValidator extends Object
# listens for player input events and attempts to validate them against
# allowed Commands selected by InteractionContext

var _event_bus: EventBus

var _approved_commands: Array[Command]
var _command_names : Array[String]


func _init(event_bus: EventBus):
	_event_bus = event_bus
	
	_event_bus.commands_approved.connect(_on_commands_approved)
	_event_bus.issue_player_command_attempt\
			.connect(_on_issue_player_command_attempt)


func _on_commands_approved(commands: Array[Command]) -> void:
	_approved_commands = commands
	_command_names = commands.map(func(cmd): 
			return cmd.get_name())


func _on_issue_player_command_attempt(attempt: String) -> void:
	# simple case
	var cmd
	var index = _command_names.find(attempt)
	if index > -1:
		cmd = _approved_commands[index]
		_event_bus.select_validated_command.emit(cmd)
		_event_bus.queue_command.emit(cmd)
	else:
		# TODO attempt to do some fuzzy validation
		# for now assume failure
		_event_bus.player_command_attempt_failed.emit()
