class_name GlobalLog 
extends Resource
# a recording of every event that occurs in the game

## Reference to a collection of data to seed the game on start
@export var seed_state : SeedState
@export var stream : Array[GameEvent]
var path = "user://data/global_log.tres"

# if events are being loaded from the log, then their emissions should not
# then be written to the log.
var loading : bool

func _ready() -> void :
	loading = false

func listen(signal_name: String) -> Callable :
	return func(arg1 = null, arg2 = null, arg3 = null, arg4 = null, arg5 = null, arg6 = null) -> void :
		var args = [ arg1, arg2, arg3, arg4, arg5, arg6 ]
		stream.append(GameEvent.new(signal_name, args))
		_save()

func _save() -> void :
	ResourceSaver.save(self, path)
