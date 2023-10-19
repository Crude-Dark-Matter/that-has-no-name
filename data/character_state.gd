# Holds state of all NPCs
extends Node

@export var characters : Array[NPC]
var _event_bus : EventBus

func _ready() -> void :
	_event_bus = get_node("/root/EventBus")
	for char in characters:
		char._init()
		char.connect_to_bus(_event_bus)
