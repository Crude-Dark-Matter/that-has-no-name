class_name NPCDemeanorMap extends Resource

# TODO when character names are known: enum{NAME}
@export_range(0,36,1) var player
@export_range(0,36,1) var char_1
@export_range(0,36,1) var char_2
@export_range(0,36,1) var char_3
@export_range(0,36,1) var char_4
@export_range(0,36,1) var char_5
@export_range(0,36,1) var char_6
@export_range(0,36,1) var char_7
@export_range(0,36,1) var char_8

var _event_bus : EventBus
var _npc : String

func connect_to_bus(npc: String, e: EventBus) -> void :
	_event_bus = e
	_npc = npc
	_connect.call("player")
	_connect.call("char_1")
	_connect.call("char_2")
	_connect.call("char_3")
	_connect.call("char_4")
	_connect.call("char_5")
	_connect.call("char_6")
	_connect.call("char_7")
	_connect.call("char_8")


# API for StateQuery to request state of NPC demeanor
func request(key: String) -> Variant:
	match key:
		"player":
			return player
		"char_1":
			return char_1
		"char_2":
			return char_2
		"char_3":
			return char_3
		"char_4":
			return char_4
		"char_5":
			return char_5
		"char_6":
			return char_6
		"char_7":
			return char_7
		"char_8":
			return char_8
		_:
			return


var _connect = func(other_char: String) -> void :
	_event_bus.attach_signal("%s_demeanor_toward_%s_changed" \
			% [_npc, other_char], [
		{ "name": "new_value", "type": TYPE_INT }	
	])
	var on_change_signal = "change_%s_demeanor_toward_%s" \
			% [_npc, other_char]
	_event_bus.attach_signal(on_change_signal, [
		{ "name": "mutate_value", "type": TYPE_INT }
	])
	# allows using other_char string to match specified method
	_event_bus.connect(on_change_signal, \
			Callable(self, "_on_demeanor_toward_%s_changed" % other_char))


func _on_demeanor_toward_player_changed(mutate_value: int) -> void:
	var new_val = player + mutate_value
	if new_val >= 36:
		player = 36
	elif new_val <= 0:
		player = 0
	else:
		player = new_val
	_event_bus.emit_signal("on_%s_demanor_toward_player_changed" % _npc, player)


func _on_demeanor_toward_char_1_changed(mutate_value: int) -> void:
	var new_val = char_1 + mutate_value
	if new_val >= 36:
		char_1 = 36
	elif new_val <= 0:
		char_1 = 0
	else:
		char_1 = new_val
	_event_bus.emit_signal("on_%s_demanor_toward_char_1_changed" % _npc, char_1)


func _on_demeanor_toward_char_2_changed(mutate_value: int) -> void:
	var new_val = char_2 + mutate_value
	if new_val >= 36:
		char_2 = 36
	elif new_val <= 0:
		char_2 = 0
	else:
		char_2 = new_val
	_event_bus.emit_signal("on_%s_demanor_toward_char_2_changed" % _npc, char_2)


func _on_demeanor_toward_char_3_changed(mutate_value: int) -> void:
	var new_val = char_3 + mutate_value
	if new_val >= 36:
		char_3 = 36
	elif new_val <= 0:
		char_3 = 0
	else:
		char_3 = new_val
	_event_bus.emit_signal("on_%s_demanor_toward_char_3_changed" % _npc, char_3)


func _on_demeanor_toward_char_4_changed(mutate_value: int) -> void:
	var new_val = char_4 + mutate_value
	if new_val >= 36:
		char_4 = 36
	elif new_val <= 0:
		char_4 = 0
	else:
		char_4 = new_val
	_event_bus.emit_signal("on_%s_demanor_toward_char_4_changed" % _npc, char_4)


func _on_demeanor_toward_char_5_changed(mutate_value: int) -> void:
	var new_val = char_5 + mutate_value
	if new_val >= 36:
		char_5 = 36
	elif new_val <= 0:
		char_5 = 0
	else:
		char_5 = new_val
	_event_bus.emit_signal("on_%s_demanor_toward_char_5_changed" % _npc, char_5)


func _on_demeanor_toward_char_6_changed(mutate_value: int) -> void:
	var new_val = char_6 + mutate_value
	if new_val >= 36:
		char_6 = 36
	elif new_val <= 0:
		char_6 = 0
	else:
		char_6 = new_val
	_event_bus.emit_signal("on_%s_demanor_toward_char_6_changed" % _npc, char_6)


func _on_demeanor_toward_char_7_changed(mutate_value: int) -> void:
	var new_val = char_7 + mutate_value
	if new_val >= 36:
		char_7 = 36
	elif new_val <= 0:
		char_7 = 0
	else:
		char_7 = new_val
	_event_bus.emit_signal("on_%s_demanor_toward_char_7_changed" % _npc, char_7)


func _on_demeanor_toward_char_8_changed(mutate_value: int) -> void:
	var new_val = char_8 + mutate_value
	if new_val >= 36:
		char_8 = 36
	elif new_val <= 0:
		char_8 = 0
	else:
		char_8 = new_val
	_event_bus.emit_signal("on_%s_demanor_toward_char_8_changed" % _npc, char_8)
