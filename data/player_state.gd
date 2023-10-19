extends Node

@export var attributes: Array[PlayerAttribute]
var primitives: Array[PlayerStatePrimitive] = []
@export var debug: bool
var _event_bus : EventBus

func _ready() -> void:
	_event_bus = get_node("/root/EventBus")
	primitives = _load_primitives.call()
	print("player_state_ready")
	for prim in primitives:
		prim._init()
		prim.connect_to_bus(_event_bus)

	for attribute in attributes:
		attribute._init()
		attribute.connect_to_bus(_event_bus)
	if debug:
		_show.call()

# called to seed intial player state
# not yet implemented
func seed(prim_values : Dictionary) -> void:
	pass

func _process(_delta) -> void:
	pass

var _show = func() -> void:
	# never show internals in game build
	if !OS.is_debug_build:
		return
	
	var debug_container = get_child(0)
	debug_container.size = Vector2(100,1000)

	_add_attribute_visualizations.call(debug_container, attributes)

	# Label between attributes and primitives
	var label = Label.new()
	label.text = "Primitives"
	debug_container.add_child(label)

	_add_primitive_visualizations.call(debug_container, primitives)

## HELPERS
var _load_primitives = func() -> Array[PlayerStatePrimitive]:
	var prims : Array[PlayerStatePrimitive] = []
	var prim_dir = "res://data/player-state/primitives"
	var prim_handles = DirAccess.get_files_at(prim_dir)
	for handle in prim_handles:
		var res = ResourceLoader.load("%s/%s" % [prim_dir, handle], "PlayerStatePrimitive") as PlayerStatePrimitive
		prims.append(res)
	return prims

var _add_attribute_visualizations = func(debug_container, atts) -> void:
	for attribute in atts:
		var h_container = HBoxContainer.new()
		var att_bar = ProgressBar.new()
		var label = Label.new()
		var val_label = Label.new()
		var att_name = attribute.resource_name
		var on_change = func(new_val) -> void:
			att_bar.value = new_val
			val_label.text = str(new_val)

		att_bar.show_percentage = false
		att_bar.max_value = attribute.max_value
		att_bar.value = attribute.value
		att_bar.custom_minimum_size = Vector2(200, 20)
		
		label.text = att_name
		label.custom_minimum_size = Vector2(50, 20)
		
		val_label.text = str(attribute.value)

		h_container.add_child(label)
		h_container.add_child(att_bar)
		debug_container.add_child(h_container)
		
		_event_bus.connect("%s_changed" % att_name, on_change)

var _add_primitive_visualizations = func(debug_container, prims) -> void:
	for primitive in prims:
		var h_container = HBoxContainer.new()
		var prim_bar = ProgressBar.new()
		var dec_button = Button.new()
		var inc_button = Button.new()
		var prim_label = Label.new()
		var val_label = Label.new()
		var prim_name = primitive.resource_name
		var on_change = func(val, _mut) -> void:
			prim_bar.value = val
			val_label.text = str(val)
		
		prim_bar.show_percentage = false
		prim_bar.max_value = primitive.max_value
		prim_bar.value = primitive.value
		prim_bar.custom_minimum_size = Vector2(200, 20)

		val_label.text = str(primitive.value)
		
		prim_label.custom_minimum_size = Vector2(50, 20)
		prim_label.text = prim_name

		dec_button.text = "-"
		inc_button.text = "+"
		
		dec_button.pressed.connect(func(): 
			_event_bus.emit_signal("change_%s" % prim_name, -1))
		inc_button.pressed.connect(func(): \
			_event_bus.emit_signal("change_%s" % prim_name, 1))
		
		h_container.add_child(prim_label)
		h_container.add_child(prim_bar)
		h_container.add_child(val_label)
		h_container.add_child(dec_button)
		h_container.add_child(inc_button)
		
		_event_bus.connect("%s_changed" % prim_name, on_change)
		debug_container.add_child(h_container)
