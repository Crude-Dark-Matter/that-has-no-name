class_name CharacterState extends Node
# Holds state of all NPCs

@export var characters : Array[NPC]
var _event_bus : EventBus

func _ready() -> void :
	_event_bus = get_node("/root/EventBus")
	for npc in characters:
		npc._init()
		npc.connect_to_bus(_event_bus)
	_event_bus.emit_signal("character_state_loaded")
