class_name NPCAttributeMap extends Resource

@export_range(0,36,1) var purple
@export_range(0,36,1) var blue
@export_range(0,36,1) var green
@export_range(0,36,1) var yellow
@export_range(0,36,1) var orange
@export_range(0,36,1) var red

var _event_bus : EventBus
var _npc : String


func connect_to_bus(npc: String, e: EventBus) -> void :
	_event_bus = e
	_npc = npc
	_connect.call("purple")
	_connect.call("blue")
	_connect.call("green")
	_connect.call("yellow")
	_connect.call("orange")
	_connect.call("red")


# API for StateQuery to request state of NPC attribute
func request(key: String) -> Variant:
	match key:
		"purple":
			return purple
		"blue":
			return blue
		"green":
			return green
		"yellow":
			return yellow
		"orange":
			return orange
		"red":
			return red
		_:
			return


var _connect = func(att: String) -> void:
	_event_bus.attach_signal("%s_%s_changed" % [_npc, att], [
		{ "name": "new_value", "type": TYPE_INT }
	])
	var on_change_signal = "change_%s_%s" % [_npc, att]
	_event_bus.attach_signal(on_change_signal, [
		{ "name": "mutate_value", "type": TYPE_INT }
	])
	# allows using att string to match att specific method
	_event_bus.connect(on_change_signal, \
			Callable(self, "_on_%s_%s_changed" % [_npc, att]))


func _on_purple_changed(mutate_value : int) -> void:
	var new_val = purple + mutate_value
	if new_val >= 36:
		purple = 36
	elif new_val <= 0:
		purple = 0
	else:
		purple = new_val
	_event_bus.emit_signal("%s_purple_changed" % _npc, purple)


func _on_blue_changed(mutate_value : int) -> void:
	var new_val = blue + mutate_value
	if new_val >= 36:
		blue = 36
	elif new_val <= 0:
		blue = 0
	else:
		blue = new_val
	_event_bus.emit_signal("%s_blue_changed" % _npc, blue)


func _on_green_changed(mutate_value : int) -> void:
	var new_val = green + mutate_value
	if new_val >= 36:
		green = 36
	elif new_val <= 0:
		green = 0
	else:
		green = new_val
	_event_bus.emit_signal("%s_green_changed" % _npc, green)


func _on_yellow_changed(mutate_value : int) -> void:
	var new_val = yellow + mutate_value
	if new_val >= 36:
		yellow = 36
	elif new_val <= 0:
		yellow = 0
	else:
		yellow = new_val
	_event_bus.emit_signal("%s_yellow_changed" % _npc, yellow)


func _on_orange_changed(mutate_value : int) -> void:
	var new_val = orange + mutate_value
	if new_val >= 36:
		orange = 36
	elif new_val <= 0:
		orange = 0
	else:
		orange = new_val
	_event_bus.emit_signal("%s_orange_changed" % _npc, orange)

	
func _on_red_changed(mutate_value : int) -> void:
	var new_val = red + mutate_value
	if new_val >= 36:
		red = 36
	elif new_val <= 0:
		red = 0
	else:
		red = new_val
	_event_bus.emit_signal("%s_red_changed" % _npc, red)
