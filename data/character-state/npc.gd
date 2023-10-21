class_name NPC extends Resource
# NPC holds all state for each non-player character
# NPC's have 

enum pronoun {SHE_HER, THEY_THEM, HE_HIM, SHE_THEY, HE_THEY}

@export var name : String
@export var description : String
@export var pronouns : pronoun
@export var attributes : NPCAttributeMap
@export var demeanors : NPCDemeanorMap

# at some point will need to have a "knowledge" dictionary for
# branching interactions and for filling in things like player_name

var _event_bus : EventBus

func _init() -> void:
	pass

func get_id() -> String:
	return name


# API for StateQuery to request state of NPC stats
func request(sub_path_arr: Array[String]) -> Variant:
	var key = sub_path_arr[0]
	var res = attributes.request(key)
	if res:
		return res
	res = demeanors.request(key)
	if res:
		return res
	# will need some sort of player knowledge table as well
	return


func connect_to_bus(e: EventBus) -> void:
	_event_bus = e
	attributes.connect_to_bus(name, _event_bus)
	demeanors.connect_to_bus(name, _event_bus)
