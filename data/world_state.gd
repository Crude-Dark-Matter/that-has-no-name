class_name WorldState 
extends Node

var _event_bus : EventBus

func _ready() -> void:
	_event_bus = get_node("/root/EventBus")
	_event_bus.emit_signal("world_state_loaded")
