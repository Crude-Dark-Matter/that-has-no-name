extends Node
## autoloaded singleton through which signals are connected and emitted

func _ready() -> void:
	pass

func _process(_delta) -> void:
	pass

func attach_signal(signal_name: String, signal_arguments = []) -> void:
	add_user_signal(signal_name, signal_arguments)

