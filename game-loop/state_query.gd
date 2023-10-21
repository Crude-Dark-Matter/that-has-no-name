class_name StateQuery 
extends Object


# used dictionary instead of enum to make more readable
const query_root_node = {
	"PLAYER": "player", 
	"CHARACTER": "character", 
	"WORLD": "world"
	}


var _player_state : PlayerState
var _character_state : CharacterState
var _world_state : WorldState


# polymorphic for state nodes
func enclose(state) -> void:
	if state is PlayerState:
		_player_state = state
	if state is CharacterState:
		_character_state = state
	if state is WorldState:
		_world_state = state


# used to query game state
# key_paths are format "TOP_NODE.sub_path_1.sub_path_n.key"
func request(key_path: String) -> Variant:
	var split_path = key_path.split(".", false)
	var sub_path_arr = split_path.slice(1)
	match split_path[0]:
		query_root_node.PLAYER:
			return _player_state.request(sub_path_arr)
		query_root_node.CHARACTER:
			return _character_state.request(sub_path_arr)
		query_root_node.WORLD:
			return _world_state.request(sub_path_arr)
		_:
			return

