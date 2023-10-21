class_name CharacterState extends Node
# Holds state of all NPCs

@export var characters : Array[NPC]
var _event_bus : EventBus
var _lookup_table : Dictionary

func _ready() -> void :
	_event_bus = get_node("/root/EventBus")
	for npc in characters:
		npc._init()
		npc.connect_to_bus(_event_bus)
		_lookup_table[npc.get_id()] = npc
	_event_bus.character_state_readied.emit()


# request is used for querying state of any character
# sub_path_arr contains keys for each sub-object
# ending in a key for the final value
func request(sub_path_arr: Array[String]) -> Variant:
	var npc_id = sub_path_arr[0]
	var npc = _lookup_table.get(npc_id)
	if npc:
		return npc.request(sub_path_arr.slice(1))
	else: return
