class_name WorldState 
extends Node

var _event_bus : EventBus

func _ready() -> void:
	_event_bus = get_node("/root/EventBus")
	_event_bus.world_state_readied.emit()


# request is used for querying state of any character
# sub_path_arr contains keys for each sub-object
# ending in a key for the final value
func request(_sub_path_arr: Array[String]) -> Variant:
	return
