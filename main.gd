extends Node

@export var log : GlobalLog

func _enter_tree() -> void :
	$"/root/EventBus".log = log
