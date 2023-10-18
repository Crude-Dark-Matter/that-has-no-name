extends Node
## autoloaded singleton through which signals are connected and emitted
var log : GlobalLog

func _ready() -> void:
	pass

func _process(_delta) -> void:
	pass

func attach_signal(signal_name: String, signal_arguments = []) -> void:
	add_user_signal(signal_name, signal_arguments)

# handles game event signals being created, so that global log can write everything
func attach_game_event_signal(signal_name: String, signal_arguments = []) -> void:
	add_user_signal(signal_name, signal_arguments)
	connect(signal_name, log.listen(signal_name))
